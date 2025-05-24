<h1><b>GooseNet 🪿 (latest Version 1.4)</b></h1> <br/>
<b>Current Features:</b> <br />
•  Registration & SignUp ✍️ <br />
•  Acquiring Coach ID as Coach 🔢 <br />
•  Connecting to Coach As Athlete 🤝<br/>
•  Adding more complex workouts is now available as a Coach <br/>
•  Adding workouts to Flocks(groups of runners<br/>
•  Viewing and sharing workout details like avg HR Laps and Paces and Route map is now available for all users <br/>
•  Profile Pictures 🖼️ <br/>
•  Password Changing <br/>
•  Seeing planned workouts is now available <br/>
• <b></b> Average Heart Rate Per Lap <br/>
• <b></b> Elevation,Pace & HR graphs <br/>
• <b>NEW!</b> Sleep Analysis! <br/>
• <b>NEW!</b> Training Summary for a time range <br/>



GooseNet Mobile in React Native is in the works!
<br/><br/>

[Trailer](https://www.youtube.com/watch?v=nds7jPN5rrs)

The Website is [here](https://goosenetcom.bsite.net/homepage.aspx)

**DataBase Used in this project is FireBase RealTime DataBase**

<h2>GarminApi Credentials are hidden now and are in the database</h2>

```csharp
public static Dictionary<string, string> GetGarminAPICredentials()
{
    // class used for Gettting and inserting data in from and to the database
    FirebaseService firebaseService = new FirebaseService();
    Dictionary<string, string> creds = firebaseService.GetData<Dictionary<string, string>>("GarminAPICredentials");

    return creds;
}
```

<h2>Constructing JSON to send Garmin API from form data</h2>


```csharp
    private void ConstructJsonFromFromData()
    {

        int intervalCount = int.Parse(Request.Form["intervalCount"]);
        int currentInterval = 0;

        List<Interval> intervalList = new List<Interval>();
        for (int i = 0; currentInterval < intervalCount; i++)
        {
            currentInterval++;

            if (Request.Form[$"step-{i + 1}-type"] != null)
            {

                intervalCount++;
                if (Request.Form[$"step-{i + 1}-type"].ToString() == "rest")
                {
                    double durationVal = 0;
                    switch (Request.Form[$"step-{i + 1}-duration-type"])
                    {
                        case "Kilometers":
                            durationVal = double.Parse(Request.Form[$"step-{i + 1}-duration"].ToString()) * 1000;
                            break;
                        case "Meters":
                            durationVal = double.Parse(Request.Form[$"step-{i + 1}-duration"].ToString());
                            break;

                        case "Minutes":
                            durationVal = double.Parse(Request.Form[$"step-{i + 1}-duration"].ToString()) * 60;
                            break;
                        case "Seconds":
                            durationVal = double.Parse(Request.Form[$"step-{i + 1}-duration"].ToString());
                            break;
                    }

                    intervalList.Add(new Interval
                    {
                        type = "WorkoutStep",
                        description = "Rest",
                        intensity = "REST",
                        durationValue = durationVal,
                        durationType = Request.Form[$"step-{i + 1}-duration-type"] == "Minutes" || Request.Form[$"step-{i + 1}-duration-type"] == "Seconds" ? "TIME" : "DISTANCE",
                        stepOrder = i + 1,

                    });
                }
                else
                {
                    Interval interval = new Interval
                    {
                        stepOrder = i + 1,
                        description = "Run",
                        repeatValue = int.Parse(Request.Form[$"step-{i + 1}-repeat"]),
                        type = "WorkoutRepeatStep",
                        repeatType = "REPEAT_UNTIL_STEPS_CMPLT",
                        intensity = "INTERVAL"
                    };

                    List<Interval> stepsList = new List<Interval>();

                    for (int j = 0; j < int.Parse(Request.Form[$"step-{i + 1}-steps"]); j++)
                    {
                        double durationVal = 0;
                        switch (Request.Form[$"step-{i + 1}-{j + 1}-duration-type"])
                        {
                            case "Kilometers":
                                durationVal = double.Parse(Request.Form[$"step-{i + 1}-{j + 1}-duration"].ToString()) * 1000;
                                break;
                            case "Meters":
                                durationVal = double.Parse(Request.Form[$"step-{i + 1}-{j + 1}-duration"].ToString());
                                break;

                            case "Minutes":
                                durationVal = double.Parse(Request.Form[$"step-{i + 1}-{j + 1}-duration"].ToString()) * 60;
                                break;
                            case "Seconds":
                                durationVal = double.Parse(Request.Form[$"step-{i + 1}-{j + 1}-duration"].ToString());
                                break;
                        }
                        stepsList.Add(new Interval
                        {
                            stepOrder = j + 1,
                            description = Request.Form[$"step-{i + 1}-{j + 1}-type"],
                            durationType = Request.Form[$"step-{i + 1}-{j + 1}-duration-type"] == "Kilometers" || Request.Form[$"step-{i + 1}-{j + 1}-duration-type"] == "Meters" ? "DISTANCE" : "TIME",
                            durationValue = durationVal,
                            intensity = Request.Form[$"step-{i + 1}-{j + 1}-type"] == "run" ? "INTERVAL" : "REST",
                            type = "WorkoutStep",
                            targetValueHigh = GooseNetUtils.PaceToSpeed(Request.Form[$"step-{i + 1}-{j + 1}-pace"]),
                            targetValueLow = GooseNetUtils.PaceToSpeed(Request.Form[$"step-{i + 1}-{j + 1}-pace"])
                        });
                    }
                    interval.steps = stepsList;
                    intervalList.Add(interval);
                }
            }
        }
        WorkoutData workout = new WorkoutData
        {

            workoutName = Request.Form["workoutName"],
            description = Request.Form["workoutDescription"],
            steps = intervalList

        };
        json = JsonConvert.SerializeObject(workout);
    }

```
