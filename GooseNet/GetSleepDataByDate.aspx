<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetSleepDataByDate.aspx.cs" Inherits="GooseNet.GetSleepDataByDate" %>


 

<%if (Request.QueryString["json"] == null && sleepData != null)
    {

        Response.Write(" <div class=\"container\">\n " +
            "  <h2>Sleep Analysis</h2>\n\n  " +
            " <div class=\"info\">\n    " +
            $" <div class=\"card\">Start Time: {GooseNet.GooseNetUtils.GetTimeOfDayFromEpoch((int)sleepData.SleepStartTimeInSeconds + sleepData.SleepTimeOffsetInSeconds)}</div>\n" +
            $"     <div class=\"card\">End Time: {GooseNet.GooseNetUtils.GetTimeOfDayFromEpoch((int)(sleepData.SleepStartTimeInSeconds + sleepData.SleepDurationInSeconds + sleepData.SleepTimeOffsetInSeconds))}</div>\n " +
            "  </div>\n\n   <div class=\"chart-section\">\n" +
            $"     <div class=\"sleep-duration-display\">Total Sleep Duration:{GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.SleepDurationInSeconds)} </div>\n" +
            "    <div style=\"width: 100%; max-width: 550px; height: 550px; margin: auto;\">\r\n    <canvas id=\"sleepPieChart\"></canvas>\r\n</div>\r\n\n" +
            "   </div>\n\n   <div class=\"info\">\n" +
            $"     <div class=\"card score-card\">REM: {GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.RemSleepInSeconds)}</div>\n " +
            $"    <div class=\"card score-card\">Awake: {GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.AwakeDurationInSeconds)}</div>\n " +
            $"    <div class=\"card score-card\">Deep Sleep: {GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.DeepSleepDurationInSeconds)}</div>\n" +
            $"     <div class=\"card score-card\">Light Sleep: {GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.LightSleepDurationInSeconds)}</div>\n" +
            "   </div>\n\n   <div class=\"info\">\n" +
            $"     <div class=\"card overall-score\">Overall Sleep Score: {sleepData.OverallSleepScore.value} - Quality: {sleepData.OverallSleepScore.qualifierKey}</div>\n" +
            "   </div>\n\n   <div class=\"info\">\n" +
            $"     <div class=\"card score-card\">Duration: {ratings["totalDuration"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">Stress: {ratings["stress"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">Deep Sleep: {ratings["deepPercentage"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">Light Sleep: {ratings["lightPercentage"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">REM Sleep: {ratings["remPercentage"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">Awake: {ratings["awakeCount"].ToLower()}</div>\n" +
            $"     <div class=\"card score-card\">Restlessness: {ratings["restlessness"].ToLower()}</div>\n" +
            $"   </div>\n </div>\n\n")
    ;











    } %>
 