using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class parseData : System.Web.UI.Page
    {

        protected string json;
        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();



            if ((Session["userName"] == null || !GooseNetUtils.IsConnectedToUser(Session, Request.QueryString["athleteName"]) ||
                Session["role"].ToString() != "coach" ) && Request.QueryString["flockName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }

            ConstructJsonFromFromData();

            if (Request.QueryString["athleteName"] != null) {

                Response.Redirect($"PostWorkout.aspx?athleteName={Request.QueryString["athleteName"]}&jsonBody={json}&workoutDate={Request.Form["workoutDate"]}");
            }
            else
            {
                Response.Redirect($"PostWorkout.aspx?flockName={Request.QueryString["flockName"]}&jsonBody={json}&workoutDate={Request.Form["workoutDate"]}");

            }

        }
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


            PlannedWorkout plannedWorkout = new PlannedWorkout
            {
                WorkoutName = Request.Form["workoutName"],
                Description = Request.Form["workoutDescription"],
                CoachName = Session["userName"].ToString(),
                Date = ConvertDateFormat(Request.Form["workoutDate"].ToString()),
                Intervals = intervalList,
                AthleteNames = new List<string>()
                

            };


            if (Request.QueryString["athleteName"] != null)
            {
                plannedWorkout.AthleteNames.Add(Request.QueryString["athleteName"]);
            }
            else
            {
                plannedWorkout.AthleteNames = firebaseService.GetData<Flock>($"Flocks/{Session["userName"].ToString()}/{Request.QueryString["flockName"].ToString()}").athletesUserNames;
            }

            Guid guid = Guid.NewGuid();

            string guidString = guid.ToString("N").Substring(0,12);
            FirebaseService fb = new FirebaseService();
            fb.InsertData($"PlannedWorkouts/{guidString}", plannedWorkout);
            json = JsonConvert.SerializeObject(workout);
            fb.InsertData($"PlannedWorkoutsJSON/{guidString}", json);            
            
        }

        private string ConvertDateFormat(string date)
        {
            if (DateTime.TryParseExact(date, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out DateTime parsedDate))
            {
                return parsedDate.ToString("%M/%d/yyyy"); // %M and %d remove leading zeros
            }
            else
            {
                throw new FormatException("Invalid date format. Expected yyyy-MM-dd.");
            }
        }
    }
}