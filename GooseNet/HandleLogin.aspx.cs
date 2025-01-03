using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleLogin : System.Web.UI.Page
    {
        private string userName, password;

        protected void Page_Load(object sender, EventArgs e)
        {
            userName = Request.Form["userName"].ToString();
            password = Request.Form["password"].ToString();
            ValidateUser();
            if (IsConnected())
            {
                Session["connected"] = true;
            }
            else
            {
                Session["connected"] = false;
            }
        }

        private bool IsConnected()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM GarminData WHERE [userName]='{userName}'");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();

            bool flag = dr.HasRows;

            conObj.Close();

            return flag;
        }

        private void ValidateUser()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"SELECT * FROM Users WHERE [userName]='{userName}' and [password]='{password}'");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            SqlDataReader dr = cmdObj.ExecuteReader();

            if (!dr.HasRows)
                Response.Redirect("LogIn.aspx");
            else
            {
                while (dr.Read())
                {
                Session["userName"] = userName;
                Session["role"] = dr["role"];
                 
                
                }
                
            }

            conObj.Close();
            if (IsConnected())
            {
                Session["connected"] = true;
            }
            else
            {
                Session["connected"] = false;
            }

            Response.Redirect("HomePage.aspx");
        }
    }
}