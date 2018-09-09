# lydia-test

## Installation

1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) install using `carthage version`
2. Run `carthage update` to build all framework
3. Open `lydia.xcodeproj` to build, test & run the project

## Exercice
```
Build an app that fetch data from this service : https://api.randomuser.me (use https://randomuser.me/api/1.0/?seed=lydia&results=10&page=1 to get 10 contacts for each api call, and increase page param to load more results.
The app must display result in a list of first names and last names, and the email under it.
The app must handle connectivity issue, and display the last results received if it can't retrieve one at launch.
Touching an item of the list should make appear a details page listing every attributes.
The app must be in Java, any third-party libraries are allowed but you'll have to justify why you use them.

Evaluate the time it should take before starting, and give it with your work, with the time it really took.

We will discuss every aspects of the exercice (technical, product, ux, ui, …) so don’t focus on one only. You can use all available tools. Take the time to be pride of the result !
```

## Estimation

At first, I estimated the project to take about half a day of work (4-5 hours) :
- 10 min to play with the API and look at how it works
- 15 min to think of the project architecture (how to handle connectivity issue, infinite tableview, data formatting)
- 10 min to think of UX (which controller to use to create which navigation, how to present user attributes)
- 1 hour to create the CoreData stack (models, fetching and saving)
- 1 hour to create API call + parser
- 1.5 hour to create storyboard with outlets on each viewcontroller
- 1 hour to create all needed tests

## Technical choices

### CoreData
CoreData is really easy to use and set up in Swift. As it allow great performance for a huge amount of data and easy to write models to encode / decode in database, I pick it as the solution to retrieve previous fetched users.

### UISplitViewController
I know it wasn't a requirement of the exercice, but I wanted to use UISplitViewController to manage UITableViewController (list of users) and UIViewContorller (attributes page). This way, I could have the expected behaviour on iPhone and an additionnal "already great working" solution for iPad.

### Libraries
I prefer not to use library as must as I can. But sometime, I don't want to spend to much time reinventing the wheel. So in this project, 3 libraries where used :

- **Alamofire**: As a great network library, it's now a evidence to include it in every project. With a few line of code, I can make a request, expect a JSON result and if needed get a nice and descriptive error of what happened.
- **SwiftyJSON**: It's a great tools to easily parse JSON. I could have use the `Codable` protocole with `JSONDecoder.decode(object)` since Swift 4 or a simple `[String: Any]` dictionnary with `dict["key"] as? String` syntax to unwrap the needed data, but it feels more intuitive with SwiftyJSON.
- **PhoneNumberKit**: I have no idea of all possible existing phone number format and phone number extension. As iOS doesn't provide a native way of formatting phone number, I used this library well known and used in Swift.

## Troubleshoots

### UISplitViewController
I had never used this UIViewController, so I needed a little time to document myself about it. I also wanted to handle properly the navigation from UITableViewController to UIViewController and it took me a little more time to find an elegant solution using a `UIStoryboardSegue`. Also, I wanted to display the UITableViewController first on iPhone (not the secondaryViewController by default).

### XCUnitTest
Same than above, I have never written a single UnitTest in Xcode. So I spend some time looking how the framework was working (to create to appropriate target after the project was already created, to setup the coredata stack properly for the test environment, solve duplicate CoreData model from both target, ...)

### Timezone
iOS doesn't have a way to convert `+2:00` into a timezone, and randomuser.me doesn't specified the timezone in any other universal format. So I had to come with a custom solution (using date computation) to retrieve the user timezone.

### randomuser.me API
When I finally for the data properly displayed, it looks akwards. Like the data was messed up (localisation in the center of the ocean, not at all at the specified address, timezone didn't match location, ...). After a while I understood that the user data wasn't consistent.

### Time estimation
Finally, I wanted to make the project perfect. So I took a little more time to : 
- customize the user's picture with shadow and border
- make the current BE the current time
- display the nationality using a emoji flag
- hide or show the password with a button (for great user privacy)

I also didn't take into account the iteration process to test and run the project several time (on different device) to make sure all was still working at every step of the project.

All this (throubleshoots + personnal UX touch) lead to the a final 8-10 hours of work.

NB: 🖌I didn't spend too much time for a great UI. I used some default iOS view to get a free great and simple UX on iPhone and iPad, used some emoji, some CALayer manipulation and a map to make the Details view a little bit sexier, but clearly, that doesn't make the app production ready ! 
