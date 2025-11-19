<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConnectAthlete.aspx.cs" Inherits="GooseNet.ConnectAthlete" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Connect Athlete</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Liquid Glass Design Styles */
        body {
            font-family: 'Inter', sans-serif;
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .animated-gradient {
            background-size: 200% 200%;
            animation: gradient-flow 15s ease infinite;
        }

        @keyframes gradient-flow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Full Screen Animated Background (Fixed to sit behind Master Page content) -->
    <div class="fixed top-0 left-0 w-full h-full bg-gradient-to-br from-cyan-500 via-blue-600 to-purple-700 animated-gradient -z-10"></div>

    <!-- Main Content Container -->
    <div class="min-h-[80vh] flex flex-col items-center justify-center p-6 text-white">
        
        <!-- Container: Tighter width on desktop (max-w-3xl) to prevent stretching -->
        <div class="glass-panel p-8 md:p-16 rounded-3xl shadow-2xl text-center w-full max-w-3xl mx-auto flex flex-col items-center gap-10">
            
            <!-- Label Text -->
            <div class="space-y-2">
                <h2 class="text-xl md:text-2xl font-medium text-cyan-100 uppercase tracking-wider">
                    Coach Connection ID
                </h2>
                <p class="text-3xl md:text-4xl font-bold drop-shadow-md leading-tight">
                    Share this ID with your athletes to connect
                </p>
            </div>

            <!-- Input and Button Wrapper -->
            <!-- Mobile: Stacked | Desktop: Row with locked heights -->
            <div class="flex flex-col md:flex-row items-stretch justify-center gap-4 w-full">
                
                <!-- Readonly Input -->
                <div class="relative flex-grow w-full">
                    <input 
                        value="<%=GetCoachId() %>" 
                        readonly 
                        class="glass-panel w-full text-center text-cyan-50 font-mono font-bold tracking-wider rounded-2xl border border-white/20 px-4 py-6 md:py-8 focus:outline-none focus:ring-4 focus:ring-cyan-400/30 transition-all duration-300 shadow-inner"
                        style="font-size: clamp(2.5rem, 5vw, 4rem);" 
                    />
                    <div class="absolute inset-0 rounded-2xl ring-1 ring-inset ring-white/10 pointer-events-none"></div>
                </div>

                <!-- Copy Button -->
                <button 
                    id="copyButton" 
                    type="button" 
                    class="group bg-white/10 hover:bg-white/20 border border-white/30 rounded-2xl p-4 md:px-8 transition-all duration-300 flex items-center justify-center shadow-lg backdrop-blur-sm md:aspect-square"
                    title="Copy to Clipboard"
                >
                    <img src="Images/copyIcon.png" alt="Copy" class="w-10 h-10 md:w-12 md:h-12 object-contain group-hover:scale-110 transition-transform duration-300" />
                </button>
            </div>

            <!-- Helper Text -->
            <p class="text-sm text-white/60 md:mt-2">
                Click the icon to copy instantly
            </p>

        </div>
    </div>

    <!-- Functionality Script -->
    <script>
        document.getElementById("copyButton").addEventListener("click", (e) => {
            e.preventDefault();
            
            const idText = '<%=GetCoachId()%>';

            navigator.clipboard.writeText(idText).then(() => {
                // Create a temporary toast notification instead of a blocking alert
                const toast = document.createElement('div');
                toast.className = 'fixed bottom-10 left-1/2 transform -translate-x-1/2 bg-white text-blue-900 px-6 py-3 rounded-full shadow-2xl font-bold z-50 transition-all duration-500 opacity-0 translate-y-10';
                toast.innerText = 'Coach ID Copied!';
                document.body.appendChild(toast);

                // Animate in
                setTimeout(() => {
                    toast.classList.remove('opacity-0', 'translate-y-10');
                }, 10);

                // Animate out
                setTimeout(() => {
                    toast.classList.add('opacity-0', 'translate-y-10');
                    setTimeout(() => toast.remove(), 500);
                }, 2500);

            }).catch(err => {
                console.error("Failed to copy text: ", err);
                alert("Failed to copy ID. Please copy manually.");
            });
        });
    </script>

</asp:Content>