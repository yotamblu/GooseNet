using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
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
                       password,
                       picString;
        private FirebaseService firebaseService;
                       
        protected void Page_Load(object sender, EventArgs e)
        {
            userName = Request.Form["userName"].ToString();
            fullName = Request.Form["fullName"].ToString();
            role = Request.Form["role"].ToString();
            email = Request.Form["email"].ToString(); 
            password = Request.Form["password"].ToString();
            picString = Request.Form["picString"].ToString();
            firebaseService = new FirebaseService();
            
            InsertToFBDB();
            
            if (role == "coach")
            {
                GenerateCoachId();
            }
            LogInUser();

           
        }

    


        private void InsertToFBDB()
        {
            if(firebaseService.GetData<User>("Users/" + userName) != null)
            {
                Session["UserNameTakenError"] = true;
                Response.Redirect("Register.aspx");
            }
            User userData = new User
            {
                UserName = userName,
                FullName = fullName,
                Role = role,
                Email = email,
                Password = GooseNetUtils.GetSha256Hash(password),
                ProfilePicString = picString,
                DefualtPicString = picString,
                ApiKey  = GooseNetUtils.GenerateApiKey()
            };
            firebaseService.InsertData("Users/"+userName,userData);
            DevNotificationHelper.SendNotification(userName);
        }


       

        private void GenerateCoachId()
        {
         
            Guid guid = Guid.NewGuid();

            string guidString = guid.ToString("N");

            string uniqueString = guidString.Substring(0, 12);
            CoachIdRow coachData = new CoachIdRow
            {
                CoachId = uniqueString,
                CoachUserName = userName
            };

            firebaseService.InsertData("CoachCodes/" + userName,coachData);


        }
        private void LogInUser()
        {

            Session["userName"] = userName;
            Session["role"] = role;
            Session["connected"] = false;
            Session["picString"] = picString;
            Response.Redirect("HomePage.aspx");


        }

        
    }
}