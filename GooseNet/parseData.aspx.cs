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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null || !GooseNetUtils.IsConnectedToUser(Session, Request.QueryString["athleteName"]) || Session["role"].ToString() != "coach")
            {
                Response.Redirect("NoAccess.aspx");
            }

            ConstructJsonFromFromData();
            Response.Redirect($"PostWorkout.aspx?athleteName=NewAthlete&jsonBody={json}&workoutDate={Request.Form["workoutDate"]}");
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
            json = JsonConvert.SerializeObject(workout);
        }
    }
}