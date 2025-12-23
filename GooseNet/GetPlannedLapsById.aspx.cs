using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GooseNet
{
    public partial class GetPlannedLapsById : System.Web.UI.Page
    {
        FirebaseService firebaseService;

        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();

            // ---------- BASIC GUARDS ----------
            if (Session["role"] == null || Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
                return;
            }

            string workoutId = Request.QueryString["workoutId"];
            if (string.IsNullOrWhiteSpace(workoutId))
            {
                Response.Redirect("NoAccess.aspx");
                return;
            }

            PlannedWorkout plannedWorkout =
                firebaseService.GetData<PlannedWorkout>($"PlannedWorkouts/{workoutId}");

            if (plannedWorkout == null || plannedWorkout.AthleteNames == null)
            {
                Response.Redirect("NoAccess.aspx");
                return;
            }

            ValidateAccess(plannedWorkout);

            // ---------- FETCH RAW WORKOUT JSON ----------
            string workoutJson =
                firebaseService.GetData<Dictionary<string,string>>($"PlannedWorkoutsJSON")[workoutId];

            if (string.IsNullOrWhiteSpace(workoutJson))
            {
                Response.Write("[]");
                return;
            }

            // ---------- BUILD LAPS ----------
            string lapsJson = WorkoutJsonToLaps(workoutJson);

            Response.ContentType = "application/json";
            Response.Write(lapsJson);
        }

        private void ValidateAccess(PlannedWorkout plannedWorkout)
        {
            string role = Session["role"].ToString();
            string userName = Session["userName"].ToString();

            if ((role == "coach" && userName != plannedWorkout.CoachName) ||
                (role == "athlete" && !plannedWorkout.AthleteNames.Contains(userName)))
            {
                Response.Redirect("NoAccess.aspx");
            }
        }

        // =========================================================
        // ================== JSON → LAPS LOGIC ====================
        // =========================================================

        private static string WorkoutJsonToLaps(string workoutJson)
        {
            // unwrap escaped JSON if needed
            if (workoutJson.StartsWith("\"{"))
                workoutJson = JsonConvert.DeserializeObject<string>(workoutJson);

            JObject root = JObject.Parse(workoutJson);
            JArray steps = (JArray)root["steps"];

            List<object> laps = new List<object>();

            foreach (JObject step in steps)
            {
                ProcessStep(step, laps);
            }

            return JsonConvert.SerializeObject(laps);
        }

        private static void ProcessStep(JObject step, List<object> laps)
        {
            string type = step["type"]?.ToString();

            // ---------- SIMPLE STEP ----------
            if (type == "WorkoutStep")
            {
                AddLapFromStep(step, laps);
                return;
            }

            // ---------- REPEAT STEP ----------
            if (type == "WorkoutRepeatStep")
            {
                int repeat = step["repeatValue"]?.Value<int>() ?? 1;
                JArray subSteps = (JArray)step["steps"];

                if (subSteps == null)
                    return;

                for (int i = 0; i < repeat; i++)
                {
                    foreach (JObject sub in subSteps)
                    {
                        AddLapFromStep(sub, laps);
                    }
                }
            }
        }


        private static string FormatPace(double metersPerSecond)
        {
            if (metersPerSecond <= 0) return "--:--";

            // Convert m/s -> min/km
            double minPerKm = (1000.0 / metersPerSecond) / 60.0;

            int min = (int)minPerKm;
            int sec = (int)Math.Round((minPerKm - min) * 60);

            if (sec == 60)
            {
                min++;
                sec = 0;
            }

            return $"{min:D2}:{sec:D2}";
        }
        private static double MetersPerSecondToMinPerKm(double metersPerSecond)
        {
            if (metersPerSecond <= 0)
                return 0; // or double.NaN if you prefer

            return (1000.0 / metersPerSecond) / 60.0;
        }

        private static void AddLapFromStep(JObject step, List<object> laps)
        {
            string intensity = step["intensity"]?.ToString();
            string durationType = step["durationType"]?.ToString();

            double durationSeconds;
            double pace;

            // ---------- REST ----------
            if (intensity == "REST")
            {
                durationSeconds = step["durationValue"]?.Value<double>() ?? 0;
                pace = 10;
            }
            else
            {
                pace = MetersPerSecondToMinPerKm(step["targetValueHigh"]?.Value<double>() ?? 0);

                if (durationType == "TIME")
                {
                    durationSeconds = step["durationValue"]?.Value<double>() ?? 0;
                }
                else if (durationType == "DISTANCE")
                {
                    double meters = step["durationValue"]?.Value<double>() ?? 0;
                    durationSeconds = meters * pace * 60 / 1000;
                }
                else
                {
                    return;
                }
            }

            laps.Add(new
            {
                duration = (int)Math.Round(durationSeconds),
                pace = pace
            });
        }
    }
}
