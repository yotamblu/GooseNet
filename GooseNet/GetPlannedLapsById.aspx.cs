using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetPlannedLapsById : System.Web.UI.Page
    {
        FirebaseService firebaseService;

        private void ValidateAccess(PlannedWorkout plannedWorkout)
        {
            if ((Session["role"].ToString() == "coach" && Session["userName"].ToString() != plannedWorkout.CoachName) || 
                (Session["role"].ToString() == "athlete" && !plannedWorkout.AthleteNames.Contains(Session["userName"].ToString())))
            {
                PlannedWorkout wo = plannedWorkout;
                Response.Redirect("NoAccess.aspx");
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();
            ValidateAccess(firebaseService.GetData<PlannedWorkout>($"PlannedWorkouts/{Request.QueryString["workoutId"]}"));
            string json = "[";
            List<Interval> intervals = firebaseService.GetData<List<Interval>>($"PlannedWorkouts/{Request.QueryString["workoutId"]}/Intervals");
            foreach (Interval interval in intervals) {

                if (interval.intensity == "REST")
                {
                    json += ($"{{\"duration\":5,\"pace\":{10}}},");
                }else
                {
                    string steps = "";

                    foreach (Interval step in interval.steps)
                    {
                       if(step.durationType == "TIME")
                        {
                            steps += $"{{\"duration\":{step.durationValue},\"pace\":{ConvertMetersPerSecondToMinPerKm(step.targetValueHigh)}}},";
                        }
                        else if (step.intensity == "REST")
                        {
                            json += ($"{{\"duration\":5,\"pace\":{10}}},");
                        }
                        else
                        {
                            steps += $"{{\"duration\":{(step.durationValue * step.targetValueHigh) / 60},\"pace\":{ConvertMetersPerSecondToMinPerKm(step.targetValueHigh)}}},";
                        }
                    }
                    for (int i = 0; i < interval.repeatValue; i++)
                    {
                        json += steps;
                    }
                }
                
            
            
            }
            json = json.Substring(0, json.Length - 1);
            json += "]";
            Response.Write(json);
        }

        private double ConvertMetersPerSecondToMinPerKm(double metersPerSecond)
        {
            if (metersPerSecond <= 0)
                throw new ArgumentException("Speed must be greater than zero.");

            double secondsPerKm = 1000 / metersPerSecond;
            double minPerKm = secondsPerKm / 60;
            return minPerKm;
        }
    }
}