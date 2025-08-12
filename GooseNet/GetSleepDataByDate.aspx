<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetSleepDataByDate.aspx.cs" Inherits="GooseNet.GetSleepDataByDate" %>

<%if (Request.QueryString["json"] == null && sleepData != null)
    {%>
        <div class="glass-panel rounded-xl p-6 md:p-8 shadow-lg mt-8">
            <h2 class="text-3xl font-bold text-blue-300 mb-6 text-center">Sleep Analysis</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-lg font-semibold shadow-md">Start Time: <%=GooseNet.GooseNetUtils.GetTimeOfDayFromEpoch((int)sleepData.SleepStartTimeInSeconds + sleepData.SleepTimeOffsetInSeconds)%></div>
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-lg font-semibold shadow-md">End Time: <%=GooseNet.GooseNetUtils.GetTimeOfDayFromEpoch((int)(sleepData.SleepStartTimeInSeconds + sleepData.SleepDurationInSeconds + sleepData.SleepTimeOffsetInSeconds))%></div>
            </div>

            <div id="sleepChartSection" class="flex flex-col items-center mb-8">
                <div class="sleep-duration-display glass-panel px-6 py-3 rounded-full border-4 border-dashed border-green-400 text-green-300 font-bold text-2xl shadow-md transition-all duration-300 hover:scale-105 hover:bg-white/10 mb-6">
                    Total Sleep Duration: <%=GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.SleepDurationInSeconds)%>
                </div>
                <div style="width: 100%; max-width: 550px; height: 550px; margin: auto;">
                    <canvas id="sleepPieChart"></canvas>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-purple-600/20">REM: <%=GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.RemSleepInSeconds)%></div>
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-red-600/20">Awake: <%=GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.AwakeDurationInSeconds)%></div>
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-blue-600/20">Deep Sleep: <%=GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.DeepSleepDurationInSeconds)%></div>
                <div class="card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-cyan-600/20">Light Sleep: <%=GooseNet.GooseNetUtils.SecondsToHHMM(sleepData.LightSleepDurationInSeconds)%></div>
            </div>

            <div class="grid grid-cols-1 mb-6">
                <div class="card overall-score glass-panel p-4 rounded-lg text-center text-white text-xl font-bold shadow-md bg-green-600/20">Overall Sleep Score: <%=sleepData.OverallSleepScore.value%> - Quality: <%=sleepData.OverallSleepScore.qualifierKey%></div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Duration: <%=ratings["totalDuration"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Stress: <%=ratings["stress"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Deep Sleep: <%=ratings["deepPercentage"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Light Sleep: <%=ratings["lightPercentage"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">REM Sleep: <%=ratings["remPercentage"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Awake: <%=ratings["awakeCount"].ToLower()%></div>
                <div class="card score-card glass-panel p-4 rounded-lg text-center text-white text-md font-semibold shadow-md bg-orange-600/20">Restlessness: <%=ratings["restlessness"].ToLower()%></div>
            </div>
        </div>
    <%}%>
