using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class ConfirmConnection : System.Web.UI.Page
    {

        protected string CoachName { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

            CheckForAccess();
        }


        public string GetCoachName()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";
            string coachName = "";
            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM CoachCodes WHERE [CoachId]='{Request.QueryString["CoachId"].ToString()}'");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();
            bool has = dr.HasRows;
            if(dr.HasRows)
            {
                while(dr.Read())
                {
                    coachName = dr["CoachUserName"].ToString();

                }
            }

            conObj.Close();

            return coachName;
        }

        public void CheckForAccess()
        {
            if (Session["userName"] == null)
            {
                Response.Redirect("NoAccess.aspx");
            }
        }
    }
}