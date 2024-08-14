#import "NSPredicate2SQL.h"
#import "NSDate+JMSHelper.h"
#import "NSDate+Helper.h"

static NSString *SQLNullValueString = @"NULL";

/* Prototypes */

NSString *SQLWhereClauseForPredictate(NSPredicate *predicate);

NSString *SQLExpressionForNSExpression(NSExpression *expression);


/* Implementation */

NSString *SQLExpressionForKeyPath(NSString *keyPath) {
    NSString *retStr = keyPath;

    NSDictionary *convertibleSetOperations = @{
                                               @"@avg": @"avg",
                                               @"@max": @"max",
                                               @"@min": @"min",
                                               @"@sum": @"sum",
                                               @"@distinctUnionOfObjects": @"distinct"
    };

    for (NSString *setOpt in [convertibleSetOperations allKeys]) {
        if ([keyPath hasSuffix:setOpt]) {
            NSString *clean = [keyPath stringByReplacingOccurrencesOfString:setOpt withString:@""];
            clean = [clean stringByReplacingOccurrencesOfString:@".." withString:@"."];

            retStr = [NSString stringWithFormat:@"%@(%@)",
                convertibleSetOperations[setOpt], clean];
        }
    }
    
    return retStr;
}

NSString *SQLSelectClauseForSubqueryExpression(NSExpression *expression) {
    NSString *retStr = nil;
    //NSAssert(0,@"%s Not Implemented",__func__);
    JMSAssert(false);
    return retStr;
}

NSString *SQLLiteralListForArray(NSArray *array) {
    NSMutableArray *retArray = [NSMutableArray array];

    for (NSExpression *obj in array) {
        [retArray addObject:SQLExpressionForNSExpression(obj)];
    }

    return [NSString stringWithFormat:@"(%@)",[retArray componentsJoinedByString:@","]];
}

NSString *SQLNamedReplacementVariableForVariable(NSString *var) {
    //NSAssert(0,@"%s Not Implemented",__func__);
    JMSAssert(false);
    return nil;
}

NSString *SQLConstantForValue(id val) {
    NSString *retStr = nil;
    if ([val isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)val;
        retStr = [@([@([date timeIntervalSince1970]) integerValue]) stringValue];
    }
    else if ([val isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)val;
                NSArray *comps = [str componentsSeparatedByString:@"."];
                if (comps.count == 2 && [comps.lastObject isEqualToString:@"length"]) {
                    retStr = [NSString stringWithFormat:@"LENGTH(%@)", comps.firstObject];
                }
                else {
                    retStr = [NSString stringWithFormat:@"\"%@\"", [val stringByReplacingOccurrencesOfString:@"'" withString:@""]];
                }
            } else if ([val respondsToSelector:@selector(intValue)]) {
                retStr = [val stringValue];
                
            } else if ([val isEqual:[NSNull null]] || val == nil) {
                retStr = SQLNullValueString;
                
            }
            else if ([val isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)val;
                NSMutableArray *mut = [NSMutableArray new];
                for (id obj in arr) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        [mut addObject:obj];
                    }
                    else if ([obj isKindOfClass:[NSString class]]) {
                        [mut addObject:[NSString stringWithFormat:@"\"%@\"", obj]];
                    }
                    else if ([obj isKindOfClass:[NSNull class]]) {
                        // do nothing
                    }
                    else {
                        [mut addObject:obj];
                        JMSAssert(false);
                    }
                }
                retStr = [NSString stringWithFormat:@"(%@)", [mut componentsJoinedByString:@","]];
            }
            else {
                retStr = SQLConstantForValue([val description]);
            }

    return retStr;
}

NSString *SQLFunctionLiteralForFunctionExpression(NSExpression *exp) {
    
    NSString *retStr = nil;

    NSDictionary *convertibleNullaryFunctions = @{
                                                  @"now" : @"date('now')",
                                                  @"random": @"random()"
                                                };

    NSDictionary *convertibleUnaryFunctions = @{@"uppercase:": @"upper",
                                                @"lowercase:": @"lower",
                                                @"abs:": @"abs"
                                                };

    NSDictionary *convertibleBinaryFunctions = @{
                                                 @"add:to:": @"+" ,
                                                 @"from:subtract:": @"-" ,
                                                 @"multiply:by:" :@"*" ,
                                                 @"divide:by:" :@"/" ,
                                                 @"modulus:by:": @"%" ,
                                                 @"leftshift:by":@"<<",
                                                 @"rightshift:by:":@">>"
                            };
    NSString *function = exp.function;
    
    if ([convertibleNullaryFunctions.allKeys containsObject:function]) {
        retStr = convertibleNullaryFunctions[ [exp function] ];
    }
    else if ([convertibleUnaryFunctions.allKeys containsObject:function]) {
    retStr = [NSString stringWithFormat:@"%@(%@)", convertibleUnaryFunctions[ function ], SQLExpressionForNSExpression( exp.arguments.firstObject )];
    }
    else if ([convertibleBinaryFunctions.allKeys containsObject:function]) {
        retStr = [NSString stringWithFormat:@"(%@ %@ %@)",
            SQLExpressionForNSExpression( exp.arguments[0] ) ,
            convertibleBinaryFunctions[ exp.arguments[1] ],
            SQLExpressionForNSExpression( exp.arguments[2] )
            ];

    } else {
     //   NSAssert(0,@"the expression %@ could not be converted because "
       //             "it uses an unconvertible function %@",expression,
      //              [expression function]);
        JMSAssert(false);
    }
    return retStr;
}

NSString *SQLExpressionForNSExpression(NSExpression *expression) {
    NSString *retStr = nil;

    switch ([expression expressionType]) {
        case NSConstantValueExpressionType:
            retStr = SQLConstantForValue([expression constantValue]);
            break;

        case NSVariableExpressionType:
            retStr = SQLNamedReplacementVariableForVariable([expression variable]);
            break;

        case NSKeyPathExpressionType:
            retStr = SQLExpressionForKeyPath([expression keyPath]);
            if ([retStr containsString:@"."]) {
                //DDLogWarn(@"analyze expression: %@", retStr);
                retStr = [retStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            }
            break;

        case NSFunctionExpressionType:
            retStr = SQLFunctionLiteralForFunctionExpression(expression);
            break;

        case NSSubqueryExpressionType:
            retStr = SQLSelectClauseForSubqueryExpression(expression);
            break;

        case NSAggregateExpressionType:
            retStr = SQLLiteralListForArray([expression collection]);
            break;
       
        case NSUnionSetExpressionType:
        case NSIntersectSetExpressionType:
        case NSMinusSetExpressionType:
            JMSAssert(false);
            // impl
            break;
        /* these can't be converted */
        case NSEvaluatedObjectExpressionType:
        case NSBlockExpressionType:
        default:
            JMSAssert(false);
            break;
    }
    return retStr;
}

NSString *SQLInfixOperatorForOperatorType(NSPredicateOperatorType type) {
    NSString *comparator = nil;
    switch (type) {
        case NSLessThanPredicateOperatorType:               comparator = @"<";      break;
        case NSLessThanOrEqualToPredicateOperatorType:      comparator = @"<=";     break;
        case NSGreaterThanPredicateOperatorType:            comparator = @">";      break;
        case NSGreaterThanOrEqualToPredicateOperatorType:   comparator = @">=";     break;
        case NSEqualToPredicateOperatorType:                comparator = @"=";     break;
        case NSNotEqualToPredicateOperatorType:             comparator = @"!="; break;
        case NSMatchesPredicateOperatorType:                comparator = @"MATCH";  break;
        case NSInPredicateOperatorType:                     comparator = @"IN";     break;
        case NSBetweenPredicateOperatorType:                comparator = @"BETWEEN";break;

        case NSLikePredicateOperatorType:
          //  NSAssert(0,@"predicate cannot be converted to a where clause because 'like' "
         //               "uses an pattern matching syntax which is not converted at this "
         //               "time.  Use 'MATCHES' instead.");
            JMSAssert(false);
            break;


        case NSContainsPredicateOperatorType:
        case NSBeginsWithPredicateOperatorType:
        case NSEndsWithPredicateOperatorType:
            comparator = @"LIKE";
            break;
        
        case NSCustomSelectorPredicateOperatorType:
           // NSAssert(0,@"predicate cannot be converted to a where clause because it calls a"
           //             "custom selector");
            JMSAssert(false);
            break;
    }
    return comparator;
}

NSString *SQLWhereClauseForComparisonPredicate(NSComparisonPredicate *predicate) {
    NSString *retStr = nil;

   // NSAssert([predicate leftExpression] && [predicate rightExpression],
   //             @"The predicate %@ could not be converted, comparison predicates "
    //            "must have both a left-hand and right-hand expression". predicate);
    JMSAssert([predicate leftExpression] && [predicate rightExpression]);
    //NSAssert([predicate comparisonPreicateModifier] == NSDirectPredicateModifier,
   //             @"Predicate %@ could not be converted to SQL because its predicate "
   //             "modifier is not NSDirectPredicateModifier.", predicate);
    JMSAssert([predicate comparisonPredicateModifier] == NSDirectPredicateModifier);
    
    //NSAssert([predicate customSelector] == NULL,
   //             @"Predicate %@ could not be converted to SQL because it uses a "
    //            "custom selector.", predicate);
    
    static NSArray *allowedSelectors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allowedSelectors = @[@"isEqual:", @"compare:", @"matches:", @"containsObject:", @"rangeOfString:options:"];
    });
    SEL selector = [predicate customSelector];
    if (selector) {
        NSString *selectorString = NSStringFromSelector(selector);
        if (![allowedSelectors containsObject:selectorString]) {
            DDLogVerbose(@"disallowed selector: %@", selectorString);
            JMSAssert([predicate customSelector] == NULL);
        }
    }

    NSString *comparator = nil;
    if (!retStr) {
        comparator = SQLInfixOperatorForOperatorType([predicate predicateOperatorType]);
    }

    //NSAssert(comparator,@"Predicate %@ could not be converted, the predicate operator "
      //                  "could not be converted.");
    JMSAssert(comparator);
    
    if (!retStr) {
        if ([comparator isEqual:@"BETWEEN"]) {
            retStr = [NSString stringWithFormat:@"(%@ %@ %@ AND %@)",
                        SQLExpressionForNSExpression([predicate leftExpression]),
                        comparator,
                        SQLExpressionForNSExpression(
                            [[predicate rightExpression] collection][0]),
                        SQLExpressionForNSExpression(
                            [[predicate rightExpression] collection][1])];
        } else if ([comparator isEqual:@"LIKE"]) {
            id left = SQLExpressionForNSExpression([predicate leftExpression]);
            NSString *right = SQLExpressionForNSExpression([predicate rightExpression]);
            if (![right isKindOfClass:[NSString class]]) {
                JMSAssert(false);
                right = [NSString stringWithFormat:@"%@", right];
            }
            if ([[right substringToIndex:1] isEqualToString:@"\""]) {
                right = [right substringWithRange:NSMakeRange(1, right.length-2)];
            }
            NSString *rightString = nil;
            switch ([predicate predicateOperatorType]) {
                case NSContainsPredicateOperatorType:
                    rightString = [NSString stringWithFormat:@"\"\%%%@%%\"", right];
                    break;
                case NSBeginsWithPredicateOperatorType:
                    rightString = [NSString stringWithFormat:@"\"%@%%\"", right];
                    break;
                case NSEndsWithPredicateOperatorType:
                    rightString = [NSString stringWithFormat:@"\"%%%@\"", right];
                    break;
                default:
                    JMSAssert(false);
                    break;
            }
            if (rightString) {
                retStr = [NSString stringWithFormat:@"(%@ %@ %@)", left, comparator, rightString];
            }
        }
        if (!retStr) {
            retStr = [NSString stringWithFormat:@"(%@ %@ %@)",
                      SQLExpressionForNSExpression([predicate leftExpression]),
                      comparator,
                      SQLExpressionForNSExpression([predicate rightExpression])];
        }
    }

    return retStr;
}

NSString *SQLWhereClauseForCompoundPredicate(NSCompoundPredicate *predicate) {

    NSMutableArray *subs = [NSMutableArray array];
    for (NSPredicate *sub in [predicate subpredicates]) {
        [subs addObject:[NSString stringWithFormat:@"(%@)", SQLWhereClauseForPredictate(sub)]];
    }

    NSString *conjunction;
    switch ([(NSCompoundPredicate *)predicate compoundPredicateType]) {
        case NSAndPredicateType:
            conjunction = @" AND ";
            break;
        case NSOrPredicateType:
            conjunction = @" OR ";
            break;
        case NSNotPredicateType:
            conjunction = @" NOT ";
            break;
    }

    return [NSString stringWithFormat:@"( %@ )", [subs componentsJoinedByString:conjunction]];
}

NSString *SQLWhereClauseForPredictate(NSPredicate *predicate) {
    NSString *retVal = nil;

    if ([predicate isKindOfClass:NSClassFromString(@"NSTruePredicate")]) {
        return @"";
    }
    else if ([predicate respondsToSelector:@selector(compoundPredicateType)]) {
        retVal = SQLWhereClauseForCompoundPredicate((NSCompoundPredicate *)predicate);
    } else if ([predicate respondsToSelector:@selector(predicateOperatorType)]) {
        retVal = SQLWhereClauseForComparisonPredicate((NSComparisonPredicate *)predicate);
    } else {
        return @"";
    }

    if ([[retVal substringToIndex:1] isEqualToString:@"("]) {
        return [retVal substringWithRange:NSMakeRange(1, retVal.length-2)];
    }
    return retVal;
}
