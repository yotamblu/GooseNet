using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class HandleFlockCreation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "coach")
            {
                Response.Redirect("noAccess.aspx");
            }

            FirebaseService service = new FirebaseService();

            if (service.GetData<Flock>($"Flocks/{Session["userName"].ToString()}/{Request.Form["FlockName"].ToString()}") == null) {


                service.InsertData($"Flocks/{Session["userName"].ToString()}/{Request.Form["FlockName"].ToString()}", new Flock
                {
                    FlockName = Request.Form["FlockName"].ToString(),
                    athletesUserNames = null
                }) ;


            }
            else
            {
                Session["flockExistsError"] = true;
                Response.Redirect("CreateFlock.aspx");
            }
            Response.Redirect("FlocksMenu.aspx");
        }
    }
}