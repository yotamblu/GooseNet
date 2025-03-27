using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace GooseNet
{
    public partial class GetPlannedWorkouts : System.Web.UI.Page
    {

        
        
        private FirebaseService firebaseService;


     
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();

            GetWorkoutsByDate(ConvertDateFormat(Request.QueryString["date"].ToString()),
                Request.QueryString["athleteName"],
                Session["role"].ToString() == "coach"
                );
        }


        private string ConvertDateFormat(string date)
        {
            if (DateTime.TryParseExact(date, "yyyy-MM-dd", null, System.Globalization.DateTimeStyles.None, out DateTime parsedDate))
            {
                return parsedDate.ToString("MM/dd/yyyy");
            }
            else
            {
                throw new FormatException("Invalid date format. Expected yyyy-MM-dd.");
            }
        }


        private string RemoveLeadingZeros(string date)
        {
            DateTime parsedDate;
            if (DateTime.TryParse(date, out parsedDate))
            {
                return parsedDate.ToString("%M/%d/yyyy"); // %M and %d prevent zero-padding
            }
            return date; // Return original if parsing fails
        }

        private void GetWorkoutsByDate(string date,string targetName,bool isCoach)
        {
            Dictionary<string, PlannedWorkout> thing = firebaseService.GetData<Dictionary<string, PlannedWorkout>>("PlannedWorkouts");
            int index = 1;

            foreach (KeyValuePair<string,PlannedWorkout> workout in firebaseService.GetData<Dictionary<string, PlannedWorkout>>("PlannedWorkouts"))
            {
                PlannedWorkout plannedWorkout = workout.Value;
               
                bool isDate = RemoveLeadingZeros(date) == plannedWorkout.Date;
                if (isDate)
                {
                    if ((isCoach && plannedWorkout.CoachName == Session["userName"].ToString() 
                        && plannedWorkout.AthleteNames.Contains(Request.QueryString["athleteName"].ToString())
                        || plannedWorkout.AthleteNames.Contains(Session["userName"].ToString())))
                    {
                        Response.Write($"<a href=\"PlannedWorkout.aspx?workoutId={workout.Key}\"><div class=\"container\">\r\n" +
                            "       \r\n" +
                            "        \r\n " +
                            "           \r\n\r\n " +
                            "       <h3>\r\n" +
                            $"            {plannedWorkout.WorkoutName}\r\n" +
                            "        </h3>\r\n\r\n " +
                            $"       <h4 style=\"color:dimgrey\">{plannedWorkout.Date}</h4>\r\n\r\n" +
                            "        <center>\r\n" +
                            "        <div class=\"bar-container\">" +
                            $"      <div id=\"chart-{index}\"></div>\r\n" +
                            $"       </div>\r\n" +
                            "        </center>\r\n\r\n" +
                            $"<span id=\"workoutID-{index}\" style=\"color:white\">{workout.Key}</span>" +
                            "</div></a>");
                        index++;
                    }
                }
            }
            //if no workouts were found for this date & athlete
            if(index == 1)
            {
                Response.Write("It seems that there are no Workouts for this Athlete on this Date");
            }
        }
    }
}