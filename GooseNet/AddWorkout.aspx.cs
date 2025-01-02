using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class AddWorkout : System.Web.UI.Page
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
            if (!IsConnected()){
                Response.Redirect("NoAccess.aspx");
            }
        }



        private bool IsConnected()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM AthleteCoachConnections WHERE [CoachUserName]='{Session["userName"].ToString()}'" +
                                          $" and [AthleteUserName] ='{Request.QueryString["athleteName"].ToString()}';");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();

            bool flag = dr.HasRows;

            conObj.Close();

            return flag;
        }

    }
}