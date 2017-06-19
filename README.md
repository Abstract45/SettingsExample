### This repo shows the different ways to implement a Settings Bundle

##### Things to watch out for:
- Do not rename the Settings Bundle (if you need to use it for multiple schemes make seperate folders and then add those Settings Bundles to the folders to keep them seperate)
- **** (I made this mistake) RegisterDefaults initializes values for the UserDefaults in the current process. Meaning it is not persistent. If you want persistent data use `UserDefaults.standard.setValue(Any?, forKey: String?)` OR `set(value: Any?, forkey: String?)`
- Make sure that each Settings Bundle is targeting the correct Targets, if you have multiple targets (Dev, QA, Prod)
- Make sure that before putting custom settings that the top level contains a group
- Double check the names for the keys in the settings Bundle
- Make sure to synchronize defaults if the app exits suddenly in the app delegate
- Make sure to set the identifier values approrpriately as this is what you will be using to grab the values later on.
- When adjusting the types and groups there are two ways of moving them around. One way is to copy and paste items as necessary, the other is to use source code on the info plist and start configuring the plist that way. *If you do end up using source code make sure that elements are placed properly.

##### Steps to configure your Settings Bundle:
1. Add files - Under Resources choose Settings Bundle
2. Make a folder in your Project Directory and change the location of your Settings Bundle
3. You can repeat these steps for multiple schemes
4. Open up Root.plist under your Settings Bundle
5. Under Preference Items is where you start building your settings
6. Always start out with a Group then the settings type underneath

##### How to register your settings Bundle in code:
1. Get Settings from Bundle
2. Get the Root.plist file as a dictionary
3. Get the PreferenceSpecifiers as an array of dictionaries
4. Set a dictionary to all the default values and their respective keys in a for loop.
5. Register userdefaults with the above dictionary

```swift
func registerSettingsBundle() {
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle") else {
        NSLog("Could not find Settings.bundle")
            return;
        }
        
        guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
            NSLog("Could not find Root.plist in settings bundle")
            return
        }
        
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else {
            NSLog("Root.plist has invalid format")
            return
        }
        
        var defaultsToRegister = [String: AnyObject]()
        for var p in preferences {
            if let k = p["Key"] as? String, let v = p["DefaultValue"] {
                NSLog("%@", "registering \(v) for key \(k)")
                defaultsToRegister[k] = v
            }
        }
        
        Userdefaults.standard.register(defaults: defaultsToRegister)
}
```

##### Grabbing specific values from the settings:
- Grabbing values is easy, simply use Userdefaults and the identifier key that you set earlier for each type. 
- Note that I am using Userdefaults.standard.string(forKey: String, you can use whatever is apropriate for your case. i.e. bool(forKey: String).

```Swift
let myValue = Userdefaults.standard.string(forKey:"Your identifier")
```
##### Changing values from within the app is as easy as simply setting the value of its identifier to a new value.


##### Setting up Title type:
1. Once you have a group with a title, create a title type setting underneath it
2. Choose an appropriate title for the setting display
3. Set the identifier and Default Value
4. Once you register the settings Bundle, you are able to pick the default Value through UserDefaults

##### Setting up Toggle Type:
- It is the same setup as Title type except the Default Value is a boolean

##### Setting up TextField Type:
- Mostly same setup as Title, except you have options for keyboard type, autocapitalization, Auto Correction

##### Setting up ChildPane Type:
1. Once you have chosen Child Pane type, Add filename key
2. Add an info plist to the Settings Bundle
3. Input the name of that info plist (Do not include .plist) for the Child pane - file name value
4. In you Child Pane add a dictionary with the title PreferenceSpecifiers
5. Add an item to this dictionary and replace "New Item" with Type
6. Set the String value to PSGroupSpecifier
7. Add a second Item and replace "New Item" with Title
8. Input whatever disclaimers/Privacy Policy etc.. (You can add multiple PSGroupeSpecifiers to make sure everything is spaced out.

##### Setting up Multiple Value Type:
1. Choose MultiValue type
2. Add identifier and Title
3. Add two Array keys "Titles" and "Values" and populate them with relevant data (Titles are what the user sees)
4. Set the default Value to any of the values that you have set in the array.

##### Setting up Slider Type:
1. Choose Slider type
2. Input default, min and max values
3. Add two new keys "Min Value Image Filename" and "Max Value Image Filename"
4. Add two image files with approximate dimension of 50 X 40 pixels (Note: Do not put large images as they will overlap in settings)
