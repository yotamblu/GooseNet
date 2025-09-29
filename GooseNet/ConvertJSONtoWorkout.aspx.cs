using FireSharp.Config;
using FireSharp;
using RestSharp;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace GooseNet
{
    public partial class ConvertJSONtoWorkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string jsonPayload;
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    jsonPayload = reader.ReadToEnd();
                }
                LogActivityData(jsonPayload);

                List<Workout> data = new ActivityJsonParser(jsonPayload).ParseActivityData();

                foreach (Workout workout in data)
                {
                    LogActivityData(workout);
                }
            }
          catch (Exception ex)
            {

                FirebaseClient client = new FirebaseClient(FireBaseConfig.pushConfig);

                client.Set("ERROR on " + DateTime.Now.ToString(), ex.Message);
            }

        }


        private void LogActivityData(string data)
        {
           

            FirebaseClient client = new FirebaseClient(FireBaseConfig.pushConfig);

            client.Set("CurrentData", data);

        }

        private void LogActivityData(Workout data)
        {
            FirebaseService service = new FirebaseService();
            string path = $"Activities/{data.UserAccessToken}/{data.WorkoutId}";
         
            service.InsertData(path, data);
           
            Response.Write(JsonConvert.SerializeObject(data));
        }
    }
}