﻿namespace ClubBAISTGolfClub.Domain
{
    public class Member
    {
        public int MemberID { get; set; }
        public string MemberFirstName { get; set; } = string.Empty;
        public string MemberLastName { get; set; } = string.Empty;
        public string MemberAddress { get; set; } = string.Empty;
        public string MemberCity { get; set; } = string.Empty;
        public string MemberProvince { get; set; } = string.Empty;
        public string MemberPostalCode { get; set; } = string.Empty;
        public string MemberCountry { get; set; } = string.Empty;
        public string MemberEmail { get; set; } = string.Empty;
        public string MemberPhoneNumber { get; set; } = string.Empty;
        public string MemberPassword {  get; set; } = string.Empty;
        public string MemberSalt { get; set; } = string.Empty;
        public DateOnly MemberDOB { get; set; }
        public int MemberSponsor1 { get; set; }
        public int MemberSponsor2 { get; set; }
        public int Prospective { get; set; }
        public string MembershipType { get; set; } = string.Empty;
        public string MemberApplicationStatus { get; set; } = string.Empty;
        public DateTime MemberDateJoined { get; set; }
        public byte[]? ApplicationFile { get; set; }
    }
}
