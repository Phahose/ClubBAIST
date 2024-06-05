using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using ClubBAISTGolfClub.Controller;
using ClubBAISTGolfClub.Domain;
using System.IO;

namespace ClubBAISTGolfClub.Pages
{
    public class SignUpModel : PageModel
    {
        [BindProperty]
        public string FirstName { get; set; } = string.Empty;
        [BindProperty]
        public string LastName { get; set; } = string.Empty;
        [BindProperty]
        public string Address { get; set; } = string.Empty;
        [BindProperty]
        public string City { get; set; } = string.Empty;
        [BindProperty]
        public string Province { get; set; } = string.Empty;
        [BindProperty]
        public string Country { get; set; } = string.Empty;
        [BindProperty]
        public string PostalCode { get; set; } = string.Empty;
        [BindProperty]
        public string Phone { get; set; } = string.Empty;
        [BindProperty]
        public string Email { get; set; } = string.Empty;
        [BindProperty]
        public string Password { get; set; } = string.Empty;
        [BindProperty]
        public DateOnly DOB { get; set; }
        [BindProperty]
        public DateTime DateJoined { get; set; } = DateTime.Today;
        [BindProperty]
        public string MembershipType { get; set; } = string.Empty;
        [BindProperty]
        public int Sponsor1ID { get; set; } 
        [BindProperty]
        public int Sponsor2ID { get; set; } 
        [BindProperty]
        public string Submit { get; set; } = string.Empty;
        [BindProperty]
        public IFormFile? ApplicationFile { get; set; }
        public string Message {  get; set; } = string.Empty;
        public string MessageClass {  get; set; } = string.Empty;
        public void OnGet()
        {
         HttpContext.Session.Clear();
        }
        public IActionResult OnPost() 
        {
            if (ApplicationFile != null && ApplicationFile.Length > 0)
            {
                using (var memoryStream = new MemoryStream())
                {
                    ApplicationFile.CopyTo(memoryStream);
                    var file = memoryStream.ToArray();

                    
                    Member member = new()
                    {
                        MemberFirstName = FirstName,
                        MemberLastName = LastName,
                        MemberAddress = Address,
                        MemberCity = City,
                        MemberProvince = Province,
                        MemberPostalCode = PostalCode,
                        MemberCountry = Country,
                        MemberPhoneNumber = Phone,
                        MemberEmail = Email,
                        MemberPassword = Password,
                        MemberDOB = DOB,
                        MembershipType = MembershipType,
                        MemberSponsor1 = Sponsor1ID,
                        MemberSponsor2 = Sponsor2ID,
                        Prospective = 1,
                        MemberDateJoined = DateJoined,
                        ApplicationFile = file
                    };
                    MemberControlls memberControlls = new MemberControlls();
                    if (memberControlls.GetMember(Email).MemberEmail == string.Empty)
                    {
                        if (memberControlls.GetMemberByID(Sponsor1ID).MembershipType != "Shareholder")
                        {
                            MessageClass = "signup_message";
                            Message = "Sponsor 1 is Not A Sponsor In our Club";
                            return Page();
                        }
                        if (memberControlls.GetMemberByID(Sponsor2ID).MembershipType != "Shareholder")
                        {
                            MessageClass = "signup_message";
                            Message = "Sponsor 2 is Not A Sponsor In our Club";
                            return Page();
                        }
                        memberControlls.AddUser(member);
                        MessageClass = "signup_message";
                        Message = "Member Added Success Fully";
                        return RedirectToPage("/MemberHome");
                    }
                    else
                    {
                        MessageClass = "signup_message";
                        Message = "Member Already Exists Try a Diffrent Email";
                        return Page();
                    }
                    
                }
            }
            return Page();
        }
    }
}
