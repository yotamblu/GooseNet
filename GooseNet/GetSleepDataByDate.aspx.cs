using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GooseNet
{
    public partial class GetSleepDataByDate : System.Web.UI.Page
    {
        protected SleepData sleepData;
        protected Dictionary<string, string> ratings;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userName"] == null || !GooseNetUtils.IsCoachingOrIsUser(Session["userName"].ToString(),Request.QueryString["athleteName"]))
            {
                Response.Write("It seems like you don't have access To this data!");
                return;   
            }
           

            

             sleepData = GetSleepData(Request.QueryString["athleteName"], Request.QueryString["date"]);
            SleepData slpDta = sleepData;

            if (sleepData == null)
            {
                Response.Write("<sapn style=\"color:black;\">There Is No Sleep Data for This Date!</span>");
                return;
            }
            ratings = GetSleepRatings();

            if (Request.QueryString["json"] != null)
            {
                Response.Write(JsonConvert.SerializeObject(new Dictionary <string,int>{
                    {"Rem Sleep",sleepData.RemSleepInSeconds}, 
                    {"Awake",sleepData.AwakeDurationInSeconds},
                    {"Deep Sleep",sleepData.DeepSleepDurationInSeconds},
                    {"Light Sleep", sleepData.LightSleepDurationInSeconds}
                }));
            }

        }


        private Dictionary<string,string> GetSleepRatings()
        {
            Dictionary<string, string> ratingsDict = new Dictionary<string, string>();
            

            foreach (SleepScoreKVP score in sleepData.SleepScores)
            {

                ratingsDict.Add(score.Key, score.Value.qualifierKey);
            }

            return ratingsDict;
        }





        private SleepData GetSleepData(string userName, string date) =>
            new FirebaseService().GetData<SleepData>($"SleepData/{GooseNetUtils.GetUserAccessTokenByUserName(userName)}/{date}");


        



        


    }
}