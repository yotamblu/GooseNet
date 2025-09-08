using System;
using System.Collections.Generic;
using System.EnterpriseServices;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FireSharp;
using FireSharp.Config;
namespace GooseNet
{
    public partial class testEndpoint : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.HttpMethod == "POST")
            {
                string jsonPayload;
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    jsonPayload = reader.ReadToEnd();
                }

                LogActivityData(jsonPayload);
                ActivityJsonParser parser = new ActivityJsonParser(jsonPayload);
                //List<Workout> workouts = parser.ParseActivityData();

                //foreach(Workout workout in workouts) { 
                
                //    LogActivityData(workout);
                //}
            }
        }


        private void LogActivityData(Workout data)
        {
            

            FirebaseClient client = new FirebaseClient(FireBaseConfig.pushConfig);
            string path = $"Activities/{data.UserAccessToken}/{data.WorkoutId}";
            client.Set(path, data);



        }

        private void LogActivityData(string data)
        {
           
            FirebaseClient client = new FirebaseClient(FireBaseConfig.pushConfig);

            client.Set(DateTime.Now.ToString(), data); 

        }
    }
}