import UIKit
import CalendarKit

class CustomCalendarExampleController: DayViewController {
  
  var data = [["Breakfast at Tiffany's",
               "New York, 5th avenue"],
              
              ["Workout",
               "Tufteparken"],
              
              ["Meeting with Alex",
               "Home",
               "Oslo, Tjuvholmen"],
              
              ["Beach Volleyball",
               "Ipanema Beach",
               "Rio De Janeiro"],
              
              ["WWDC",
               "Moscone West Convention Center",
               "747 Howard St"],
              
              ["Google I/O",
               "Shoreline Amphitheatre",
               "One Amphitheatre Parkway"],
              
              ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
               "Oslo Gardermoen"],
              
              ["💻📲 Developing CalendarKit",
               "🌍 Worldwide"],
              
              ["Software Development Lecture",
               "Mikpoli MB310",
               "Craig Federighi"],
              
  ]
  
  var generatedEvents = [EventDescriptor]()
  var alreadyGeneratedSet = Set<Date>()
  
  var colors = [UIColor.blue,
                UIColor.yellow,
                UIColor.green,
                UIColor.red]

  private lazy var dateIntervalFormatter: DateIntervalFormatter = {
    let dateIntervalFormatter = DateIntervalFormatter()
    dateIntervalFormatter.dateStyle = .none
    dateIntervalFormatter.timeStyle = .short

    return dateIntervalFormatter
  }()

  override func loadView() {
    calendar.timeZone = TimeZone(identifier: "Europe/Paris")!

    dayView = DayView(calendar: calendar)
    view = dayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CalendarKit Demo"
    navigationController?.navigationBar.isTranslucent = false
    dayView.autoScrollToFirstEvent = true
    reloadData()
  }
  
  // MARK: EventDataSource
  
  override func eventsForDate(_ date: Date) -> [EventDescriptor] {
    if !alreadyGeneratedSet.contains(date) {
      alreadyGeneratedSet.insert(date)
      generatedEvents.append(contentsOf: generateEventsForDate(date))
    }
    return generatedEvents
  }
  
  private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
    var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
    var events = [Event]()
    
    for i in 0...4 {
      let event = Event()

      let duration = Int.random(in: 60 ... 160)
      event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))

      var info = data.randomElement() ?? []
      
      let timezone = dayView.calendar.timeZone
      print(timezone)

      info.append(dateIntervalFormatter.string(from: event.dateInterval.start, to: event.dateInterval.end))
      event.text = info.reduce("", {$0 + $1 + "\n"})
      event.color = colors.randomElement() ?? .red
      event.isAllDay = Bool.random()
      event.lineBreakMode = .byTruncatingTail

      events.append(event)
      
      let nextOffset = Int.random(in: 40 ... 250)
      workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
      event.userInfo = String(i)
    }

    print("Events for \(date)")
    return events
  }
  
  // MARK: DayViewDelegate
  
  private var createdEvent: EventDescriptor?
  
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
  }
  
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    endEventEditing()
    print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    beginEditing(event: descriptor, animated: true)
    print(Date())
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
    print("Did Tap at date: \(date)")
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    endEventEditing()
    print("DayView did begin dragging")
  }
  
  var dayCounter = 0
  override func dayView(dayView: DayView, willMoveTo date: Date) {
    let components = date.get(.day, .month, .year)
    if let day = components.day, let month = components.month, let year = components.year {
        print("day: \(day), month: \(month), year: \(year)")
      if day == 14 {
        dayCounter = dayCounter + 1
        var counter = 7
        #if DEBUG
        #else
        counter = 7
        #endif
        if dayCounter >= counter {
          openPhotosViewController()
        }
      }
    }
    
    print("DayView = \(dayView) will move to: \(date)")
  }
  
  func openPhotosViewController() {
    let storyboard = UIStoryboard(name: "PhotosViewController", bundle: nil)
    let viewController = storyboard.instantiateInitialViewController()! as! PhotosViewController
    let controller = UINavigationController(rootViewController: viewController)
    present(controller, animated: true)
  }
  
  override func dayView(dayView: DayView, didMoveTo date: Date) {
    print("DayView = \(dayView) did move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    print("Did long press timeline at date \(date)")
    // Cancel editing current event and start creating a new one
    endEventEditing()
    let event = generateEventNearDate(date)
    print("Creating a new event")
    create(event: event, animated: true)
    createdEvent = event
  }
  
  private func generateEventNearDate(_ date: Date) -> EventDescriptor {
    let duration = (60...220).randomElement()!
    let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
    let event = Event()
    
    event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))
    
    var info = data.randomElement()!

    info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
    event.text = info.reduce("", {$0 + $1 + "\n"})
    event.color = colors.randomElement()!
    event.editedEvent = event

    return event
  }
  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("did finish editing \(event)")
    print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")
    
    if let _ = event.editedEvent {
      event.commitEditing()
    }
    
    if let createdEvent = createdEvent {
      createdEvent.editedEvent = nil
      generatedEvents.append(createdEvent)
      self.createdEvent = nil
      endEventEditing()
    }
    
    reloadData()
  }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

