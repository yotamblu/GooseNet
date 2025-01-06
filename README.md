<h1><b>GooseNet 🪿</b></h1> <br/>
<b>Current Features:</b> <br />
•  Registration & SignUp ✍️ <br />
•  Acquiring Coach ID as Coach 🔢 <br />
•  Connecting to Coach As Athlete 🤝<br/>
•  Inserting Simple Wokrouts(intervals of time/distance on a certain pace) is now possible as a Coach<br/>

The Website is [here](https://goosenetcom.bsite.net/homepage.aspx)

**DataBase Used in this project is FireBase RealTime DataBase**

<h2>GarminApi Credentials are hidden now and are in the database</h2>

```csharp
public static Dictionary<string, string> GetGarminAPICredentials()
{
    FirebaseService firebaseService = new FirebaseService();
    Dictionary<string, string> creds = firebaseService.GetData<Dictionary<string, string>>("GarminAPICredentials");

    return creds;
}
