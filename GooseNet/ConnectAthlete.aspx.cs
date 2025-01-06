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
        private FirebaseService firebaseService;

        protected void Page_Load(object sender, EventArgs e)
        {
            firebaseService = new FirebaseService();   
        }

        protected string GetCoachId() => firebaseService.GetData<CoachIdRow>("CoachCodes/" + Session["userName"].ToString()).CoachId;


        
        

        
    }
}