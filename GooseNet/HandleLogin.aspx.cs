using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleLogin : System.Web.UI.Page
    {
        private string userName, password;
        private FirebaseService firebaseService;
        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();
            userName = Request.Form["userName"].ToString();
            password = Request.Form["password"].ToString();
            ValidateUser();
            Response.Redirect("HomePage.aspx");
          
        }

        


        private bool IsConnected()
        {
            return firebaseService.GetData<GarminData>("GarminData/"+userName) != null;
        }

        private void ValidateUser()
        {
            User user = (User)firebaseService.GetData<User>("Users/"+userName);
            if(user != null && user.Password == GooseNetUtils.GetSha256Hash(password))
            {
                Session["userName"] = userName;
                Session["role"] = user.Role;
                if(user.Role == "athlete")
                {
                    Session["connected"] = IsConnected();

                }
                
                Response.Redirect("HomePage.aspx");
            }
            else
            {
                Response.Redirect("LogIn.aspx");

            }

        }


       
    }
}