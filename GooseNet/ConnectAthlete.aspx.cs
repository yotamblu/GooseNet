using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class ConnectAthlete : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }


        protected string GetCoachId()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";
            string CoachId = "";
            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM CoachCodes WHERE [CoachUserName]='{Session["userName"].ToString()}'");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();



            {
                while (dr.Read())
                {

                    CoachId = dr["CoachId"].ToString();

                }



                conObj.Close();

                return CoachId;
            }
        }
    }
}