using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleConnection : System.Web.UI.Page
    {
        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckForAccess();

            if (Session["role"].ToString() == "coach")
            {
                Response.Redirect("NoAccess.aspx");
            }
            ConnectToCoach();
        }


        private void ConnectToCoach()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"INSERT INTO AthleteCoachConnections VALUES('{Request.QueryString["CoachName"]}','{Session["userName"]}')");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            cmdObj.ExecuteNonQuery();

            conObj.Close();
        }
    }
}