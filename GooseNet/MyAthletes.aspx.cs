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
            if (Session["userName"] == null) Response.Redirect("NoAccess.aspx");
            
            firebaseService = new FirebaseService();
        }


        protected void ShowConnectedAthletes(List<String> athletes)
        {
            for (int i = 0; i < athletes.Count; i++)
            {
                string name = athletes.ElementAt(i);
                Response.Write("<div class=\"athlete-card\">\r\n " +
                   $"     <img class=\"profile-pic\" src=\"{GooseNetUtils.GetUserPicStringByUserName(name)}\" alt=\"@{name}'s profile\" />\r\n" +
                   $"      <h2 class=\"username\">@{name}</h2>\r\n      <button class=\"athlete-button\" onclick=\"location.href='AthletePage.aspx?athleteName={name}'\">View Athlete Page</button>\r\n" +
                    "    </div>");
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