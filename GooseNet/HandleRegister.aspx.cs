using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleRegister : System.Web.UI.Page
    {
        private string userName,
                       fullName,
                       role,
                       email,
                       password;
        
                       
        protected void Page_Load(object sender, EventArgs e)
        {
            userName = Request.Form["userName"].ToString();
            fullName = Request.Form["fullName"].ToString();
            role = Request.Form["role"].ToString();
            email = Request.Form["email"].ToString(); 
            password = Request.Form["password"].ToString();

            InsertUser();
            if (role == "coach")
            {
                GenerateCoachId();
            }
            LogInUser();

           
        }

        private void GenerateCoachId()
        {
            Guid guid = Guid.NewGuid();

            string guidString = guid.ToString("N");

            string uniqueString = guidString.Substring(0, 12);


            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"INSERT INTO CoachCodes VALUES('{userName}','{uniqueString}')");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            cmdObj.ExecuteNonQuery();

            conObj.Close();


        }
        private void LogInUser()
        {

            Session["userName"] = userName;
            Session["role"] = role;
            Response.Redirect("HomePage.aspx");



        }

        private void InsertUser()
        {
            string conStr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = |DataDirectory|\GooseNetDB.mdf; Integrated Security = True";

            SqlConnection conObj = new SqlConnection(conStr);
            string cmdStr = string.Format($"INSERT INTO Users VALUES('{userName}','{fullName}','{role}','{email}','{password}')");
            SqlCommand cmdObj = new SqlCommand(cmdStr, conObj);
            conObj.Open();
            cmdObj.ExecuteNonQuery();

            conObj.Close();

        }
    }
}