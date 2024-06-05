#nullable disable
using ClubBAISTGolfClub.Controller;
using ClubBAISTGolfClub.Domain;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Text.Json;

namespace ClubBAISTGolfClub.Pages
{
    public class TeeTimeReservationsModel : PageModel
    {
        public List<TeeTime> TeeTimeList { get; set; } = new();
        public string Email { get; set; } = string.Empty;
        public Member Member { get; set; } = new();
        [BindProperty]
        public string Submit { get; set; } = string.Empty;
        [BindProperty]
        public int TeeTimeID { get; set; }
        public TeeTime TeeTime { get; set; } = new();
        public string Message { get; set; } = string.Empty;
        public string ErrorMessage { get; set; } = string.Empty;
        public bool UpdateTee {  get; set; } = false;
        public bool DeleteTime {  get; set; } = false;
        public TeeTime TeeTimeInfo { get; set; } = new();
        [BindProperty]
        public int Player1Id { get; set; }
        [BindProperty]
        public int Player2Id { get; set; }
        [BindProperty]
        public int Player3Id { get; set; }
        [BindProperty]
        public int Player4Id { get; set; }
        public List<int> PlayerList { get; set; } = new();
        public List<string> ErrorList { get; set; } = new();
        public string BookingTime {  get; set; } = string.Empty;
        [BindProperty]
        public int PlayerNumber { get; set; }
        public string MemberInfoString { get; set; } = string.Empty;
        public string SuccessMessage { get; set; } = string.Empty;
        [BindProperty]
        public DateTime Date { get; set; }
        [BindProperty]
        public string Time { get; set; } = string.Empty;
        public void OnGet()
        {
            TeeTime = new();
            Email = HttpContext.Session.GetString("Email")!;
            MemberControlls memberControlls = new MemberControlls();
            Member = memberControlls.GetMember(Email);
            TeeTimeController teeTimeController = new();
            TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
        }

        public void OnPost()
        {
            TeeTimeController teeTimeController = new();
            MemberControlls memberControlls = new();
            switch (Submit)
            {
                case "Delete Tee Time":
                    DeleteTime = true;
                    Email = HttpContext.Session.GetString("Email")!;
                    Member = memberControlls.GetMember(Email);
                    TeeTime = teeTimeController.GetTeeTimeByID(TeeTimeID);
                    HttpContext.Session.SetInt32("TeeTimeID", TeeTimeID);
                    if (TeeTime.ReservationStatus == "")
                    {
                        ErrorMessage = "This Tee Time does not Exist Try A Diffrent Number";
                    }
                    if (TeeTime.MemberID != Member.MemberID)
                    {
                        TeeTime = new();
                        ErrorMessage = "You dont have this Tee Time Try A diffrent ID";
                    }
                    TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
                    break;
                case "Delete":
                    Email = HttpContext.Session.GetString("Email")!;
                    Member = memberControlls.GetMember(Email);
                    TeeTimeID = (int)HttpContext.Session.GetInt32("TeeTimeID")!;
                    Message = teeTimeController.CancelTeeTime(TeeTimeID);
                    TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
                break;
                case "Cancel":
                    Email = HttpContext.Session.GetString("Email")!;
                    Member = memberControlls.GetMember(Email);
                    TeeTime = new();
                    TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
                break;
                case "Update Tee Time":
                    Email = HttpContext.Session.GetString("Email")!;
                    Member = memberControlls.GetMember(Email);
                    TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
                    TeeTime = teeTimeController.GetTeeTimeByID(TeeTimeID);
                    if (TeeTimeID > 0)
                    {
                        UpdateTee = true;
                        HttpContext.Session.SetInt32("TeeTimeID", TeeTimeID);
                    }                
                    break;
                case "Update":
                    Email = HttpContext.Session.GetString("Email")!;
                    Member = memberControlls.GetMember(Email);
                    TeeTimeList = teeTimeController.GetMemberTeeTime(Member.MemberID);
                    TeeTimeID = (int)HttpContext.Session.GetInt32("TeeTimeID");
                    if (TeeTimeID > 0)
                    {
                        TeeTime = teeTimeController.GetTeeTimeByID(TeeTimeID);

                        Member member = memberControlls.GetMemberByID(Player1Id);
                        
                        if (Player1Id != 0)
                        {
                            PlayerList.Add(Player1Id);
                        }
                        if (Player2Id != 0)
                        {
                            PlayerList.Add(Player2Id);
                        }
                        if (Player3Id != 0)
                        {
                            PlayerList.Add(Player3Id);
                        }
                        if (Player4Id != 0)
                        {
                            PlayerList.Add(Player4Id);
                        }

                        bool playersvalid = true;
                        for (int i = 0; i < PlayerList.Count; i++)
                        {
                            member = memberControlls.GetMemberByID(PlayerList[i]);
                            if (member.MembershipType != "")
                            {
                                if (member.MemberApplicationStatus != "Pending")
                                {
                                    if (member.MembershipType != Member.MembershipType)
                                    {
                                        if (member.MembershipType == "Silver")
                                        {
                                            TimeOnly startTime = new TimeOnly(15, 0); // 3:00 PM
                                            TimeOnly endTime = new TimeOnly(17, 30); // 5:30 PM
                                            if (TimeOnly.Parse(BookingTime) >= startTime && TimeOnly.Parse(BookingTime) <= endTime)
                                            {
                                                Message = $"Player with ID of ${PlayerList[i]} cannot play at this Time Because They are a Silver Member The can Play Before 3:00 PM and After 5:30PM";
                                                ErrorList.Add(Message);
                                                playersvalid = false;
                                            }
                                        }
                                        else if (member.MembershipType == "Bronze")
                                        {
                                            TimeOnly startTime = new TimeOnly(15, 0); // 3:00 PM
                                            TimeOnly endTime = new TimeOnly(18, 0); // 5:30 PM
                                            if (TimeOnly.Parse(BookingTime) >= startTime && TimeOnly.Parse(BookingTime) <= endTime)
                                            {
                                                Message = $"Player with ID of ${PlayerList[i]} cannot play at this Time Because They are a Bronze Member The can Play Before 3:00 PM and After 6:00PM";
                                                ErrorList.Add(Message);
                                                playersvalid = false;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    Message = $"Player ID {PlayerList[i]} Cannot Play - Membership not Approved";
                                    ErrorList.Add(Message);
                                }

                            }
                            else
                            {
                                Message = $"Player ID {PlayerList[i]} doesent Exist - Invalid Player ID";
                                ErrorList.Add(Message);
                                playersvalid = false;
                            }
                        }
                        if (playersvalid)
                        {
                            TeeTimeInfo = teeTimeController.GetTeeTime(TeeTime.Date, TeeTime.Time.ToString());
                            TeeTime updatedTeeTime = new TeeTime();
                            {
                                updatedTeeTime.TeeTimeID = TeeTimeID;
                                updatedTeeTime.Date = Date;
                                updatedTeeTime.Time = TimeSpan.Parse(Time);
                                updatedTeeTime.MemberID = member.MemberID;
                                updatedTeeTime.Player1ID = Player1Id;
                                updatedTeeTime.Player2ID = Player2Id;
                                updatedTeeTime.Player3ID = Player3Id;
                                updatedTeeTime.Player4ID = Player4Id;
                                updatedTeeTime.NumberOfPlayers = PlayerList.Count;
                                if (PlayerList.Count >= 4)
                                {
                                    updatedTeeTime.ReservationStatus = "Reserved";
                                }
                                else
                                {
                                    updatedTeeTime.ReservationStatus = "Open";
                                }
                                
                            }
                            /*if (TeeTimeInfo.ReservationStatus == "Reserved")
                            {
                                Message = "This Time Slot is Reserved";
                                ErrorList.Add(Message);
                            }
                            if (TeeTimeInfo.NumberOfPlayers == 1)
                            {
                                if (TeeTime.NumberOfPlayers > 3)
                                {
                                    Message = "This Time Slot Can Have Only three More Players";
                                    ErrorList.Add(Message);
                                }
                            }
                            if (TeeTimeInfo.NumberOfPlayers == 2)
                            {
                                if (TeeTime.NumberOfPlayers > 2)
                                {
                                    Message = "This Time Slot Can Have Only two More Players";
                                    ErrorList.Add(Message);
                                }
                            }
                            if (TeeTimeInfo.NumberOfPlayers == 3)
                            {
                                if (TeeTime.NumberOfPlayers > 1)
                                {
                                    Message = "This Time Slot Can Have Only One More Player";
                                    ErrorList.Add(Message);
                                }
                            }*/
                            if (ErrorList.Count == 0)
                            {
                                SuccessMessage = teeTimeController.UpdateTeeTime(updatedTeeTime).ToString();
                            }

                        }
                        else
                        {
                            Message = "Please Select a Tee Time";
                            ErrorList.Add(Message);
                        }
                    }

                break;
            }
        }
        public static string GetFormattedDate(DateTime date)
        {
            string[] suffixes = { "th", "st", "nd", "rd" };

            int day = date.Day;
            string suffix = (day >= 11 && day <= 13) || (day % 10 > 3) ? suffixes[0] : suffixes[day % 10];

            return date.ToString($"MMMM d'{suffix}' yyyy");
        }
    }
}
