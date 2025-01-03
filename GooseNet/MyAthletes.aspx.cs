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
        protected void Page_Load(object sender, EventArgs e)
        {
            
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

            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM AthleteCoachConnections WHERE CoachUserName = '{Session["userName"].ToString()}';");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader reader = cmdObj.ExecuteReader();

            while (reader.Read())
            {
                athletes.Add(reader["AthleteUserName"].ToString());
            }

            conObj.Close();

            return athletes;
        }

    }
}