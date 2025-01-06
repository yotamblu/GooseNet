using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class MyAthletes : System.Web.UI.Page
    {

        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();
        }


        protected void ShowConnectedAthletes(List<String> athletes)
        {
            for (int i = 0; i < athletes.Count; i++)
            {
                string name = athletes.ElementAt(i);
                Response.Write(" <fieldset>\r\n " +
                    $"Name:{name}\r\n        " +
                   $"<button class=\"workoutBtns\"><a href=\"AddWorkout.aspx?athleteName={name}\">Add Workout</a></button>\r\n " +
                    "       <button class=\"workoutBtns\">Show Planned Worokouts</button>\r\n " +
                    "   </fieldset><br/>");
            }
        }
        
        protected List<string> GetConnectedAthletes()
        {
            List<string> athletes = new List<string>();
            Dictionary<string, AthleteCoachConnection> rows = firebaseService.GetData<Dictionary<string, AthleteCoachConnection>>("AthleteCoachConnections");
            foreach(KeyValuePair<string,AthleteCoachConnection> kvp in rows)
            {
                if(kvp.Value.CoachUserName == Session["userName"].ToString())
                {
                    athletes.Add(kvp.Value.AthleteUserName);
                }
            }
            return athletes;
        }

        

    }
}