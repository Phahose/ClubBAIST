-- Members Table
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Address VARCHAR(255) NOT NULL,
	City VARCHAR(255),
	Province VARCHAR(225),
	Country VARCHAR(225),
    PostalCode VARCHAR(10),
    Phone VARCHAR(20),
    Email VARCHAR(100),
	MemberPassword NVARCHAR(255) NOT NULL,
	Salt NVARCHAR(255) NOT NULL,
    DateOfBirth DATE,
    MembershipType VARCHAR(20),
    Sponsor1ID INT,
    Sponsor2ID INT,
    ApplicationStatus VARCHAR(20),
    DateJoined DATE,
	Prospective INT
);

Drop Column ApplicantName;

--Drop Table Members
CREATE TABLE ClubMemberApplications (
    ApplicationID INT IDENTITY(1,1)PRIMARY KEY,
    ApplicantName VARCHAR(50) NOT NULL,
    Sponsor1Name VARCHAR(100) NOT NULL,
    Sponsor2Name VARCHAR(100) NOT NULL,
    ApplicationStatus VARCHAR(20),
    ApplicationDate DATE,
	ApplicationFormFile VARBINARY(MAX)
);
ALTER TABLE ClubMemberApplications
ADD Shareholder2Status VARCHAR(20)

-- TeeTimes Table
CREATE TABLE TeeTimes (
    TeeTimeID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT,
    Date DATE,
    TeeTime TIME,
    NumberOfPlayers INT DEFAULT 0,
	Player1ID INT,
	Player2ID INT,
	Player3ID INT,
	Player4ID INT,
    ReservationStatus VARCHAR(20),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
);
DROP Table TeeTimes

CREATE TABLE TeeTimePlayers (
	TeeTimePlayerID INT IDENTITY (1,1) PRIMARY KEY,
	TeeTimeID INT FOREIGN KEY REFERENCES TeeTimes(TeeTimeID),
	BookIngPlayerID INT
);
ALTER TABLE TeeTimePlayers
ADD BookIngPlayerID INT
-- StandingTeeTimeRequests Table
--CREATE TABLE StandingTeeTimeRequests (
--    RequestID INT IDENTITY(1,1) PRIMARY KEY,
--    MemberID INT,
--    RequestedDayOfWeek VARCHAR(20),
--    RequestedTeeTime TIME,
--    RequestedStartDate DATE,
--    RequestedEndDate DATE,
--    PriorityNumber INT,
--    ApprovedTeeTime TIME,
--    ApprovedBy VARCHAR(50),
--    ApprovedDate DATE,
--    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
--);

-- Employees Table
--CREATE TABLE Employees (
--    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
--    FirstName VARCHAR(50) NOT NULL,
--    LastName VARCHAR(50) NOT NULL,
--    Position VARCHAR(50) NOT NULL,
--    HireDate DATE NOT NULL
--);

-- SpecialEvents Table
--CREATE TABLE SpecialEvents (
--    EventID INT PRIMARY KEY,
--    EventName VARCHAR(100),
--    EventDate DATE,
--    Restrictions VARCHAR(255)
--);

-- Scores Table
CREATE TABLE Scores (
	ScoreID INT IDENTITY(1,1) PRIMARY KEY,
	MemberID INT,
	PlayerName VARCHAR(50),
	Date DATE,
    PlayerNumber INT,
    Player1Name VARCHAR(50),
    Player2Name VARCHAR(50),
    Player3Name VARCHAR(50),
    Player4Name VARCHAR(50),
	Hole1Score INT,
	Hole2Score INT,
	Hole3Score INT,
	Hole4Score INT,
	Hole5Score INT,
	Hole6Score INT,
	Hole7Score INT,
	Hole8Score INT,
	Hole9Score INT,
	Hole10Score INT,
	Hole11Score INT,
	Hole12Score INT,
	Hole13Score INT,
	Hole14Score INT,
	Hole15Score INT,
	Hole16Score INT,
	Hole17Score INT,
	Hole18Score INT,
	TotalScore INT,
);

DROP TABLE Scores

-- Handicaps Table
--CREATE TABLE Handicaps (
--    HandicapID INT PRIMARY KEY,
--    MemberID INT,
--    HandicapIndex DECIMAL(4, 2),
--    Last20Average DECIMAL(4, 2),
--    Best8Average DECIMAL(4, 2),
--    Last20RoundScores TEXT,
--    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
--);
GO
Create Procedure CreateApplication (@FirstName varchar(50), @LastName VARCHAR(50),
									@Address VARCHAR(255),  @City VARCHAR(255),
									@Province VARCHAR(255), @Country VARCHAR(255),
									@PostalCode VARCHAR(10),@Phone VARCHAR(20),
									@Email VARCHAR(100), @MemberPassword NVARCHAR(255),
									@DateOfBirth DATE,   @MembershipType VARCHAR(20),
									@Sponsor1ID INT,     @Sponsor2ID INT,
									@Salt NVARCHAR(225), @ApplicationStatus VARCHAR(20),
									@DateJoined DATE, @ApplicationFile VARBINARY(max))
AS
	IF @FirstName is NULL 
	 RAISERROR ('The FirstName Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @LastName IS NULL 
	 RAISERROR ('The LastName Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Address IS NULL 
	 RAISERROR ('The Address Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Phone IS NULL 
	 RAISERROR ('The Phone Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Email IS NULL 
	 RAISERROR ('The Email Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @MemberPassword IS NULL 
	 RAISERROR ('The MemberPassword Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Sponsor1ID IS NULL 
	 RAISERROR ('The Sponsor1ID Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Sponsor2ID IS NULL 
	 RAISERROR ('The Sponsor2ID Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @DateOfBirth IS NULL 
	 RAISERROR ('The DateOfBirth Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @MembershipType IS NULL 
	 RAISERROR ('The MembershipType Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF NOT EXISTS (SELECT * FROM Members WHERE MemberID = @Sponsor1ID AND  MembershipType = 'Shareholder') 
	 RAISERROR ('Sponsor Member 1 is not a Sponsor in Our Club ~ INSERT ERROR',0,1)
	ELSE IF NOT EXISTS (SELECT * FROM Members WHERE MemberID = @Sponsor2ID AND  MembershipType = 'Shareholder')	
     RAISERROR ('Sponsor Member 2 is not a Sponsor in Our Club ~ INSERT ERROR',0,1)
	ELSE
	BEGIN
		INSERT INTO Members (
				FirstName,
				LastName,
				Address,
				City,
				Province,
				Country,
				PostalCode,
				Phone,
				Email,
				MemberPassword,
				Salt,
				DateOfBirth,
				MembershipType,
				Sponsor1ID,
				Sponsor2ID,
				ApplicationStatus,
				DateJoined,
				Prospective)

		VALUES (@FirstName,
				@LastName,
				@Address,
				@City,
				@Province,
				@Country,
				@PostalCode,
				@Phone,
				@Email,
				@MemberPassword,
				@Salt,
				@DateOfBirth,
				@MembershipType,
				@Sponsor1ID,
				@Sponsor2ID,
				@ApplicationStatus,
				@DateJoined,
				1)
		DECLARE @Sponsor1Name VARCHAR(255);
		DECLARE @Sponsor2Name VARCHAR(255);
		DECLARE @MemberID INT;

	    SELECT @Sponsor1Name = FirstName +' ' + LastName FROM Members WHERE MemberID = @Sponsor1ID
		SELECT @Sponsor2Name =  FirstName +' ' + LastName FROM Members WHERE MemberID = @Sponsor2ID
		SELECT @MemberID = MemberID FROM Members WHERE Email = @Email
		INSERT INTO ClubMemberApplications(
		Sponsor1Name,
		Sponsor2Name,
		ApplicationStatus,
		ApplicationDate,
		ApplicationFormFile,
		ApplicantName,
		ApplicantID,
		Shareholder1Status,
		Shareholder2Status,
		Sponsor1ID,
		Sponsor2ID)

		VALUES(
		@Sponsor1Name,
		@Sponsor2Name,
		@ApplicationStatus,
		@DateJoined,
		@ApplicationFile,
		@FirstName + ' ' +@LastName,
		@MemberID,
		'Pending',
		'Pending',
		@Sponsor1ID,
		@Sponsor2ID)
	END
Drop Procedure CreateApplication

GO
CREATE PROCEDURE BookTeeTime
    @PlayerID INT,
    @Date DATE,
    @Time TIME,
	@Player1ID INT,
	@Player2ID INT,
	@Player3ID INT,
	@Player4ID INT,
    @NumberOfPlayers INT
AS
BEGIN
    DECLARE @PlayerCount INT;

    -- Check for required parameters
    IF @PlayerID IS NULL OR @Date IS NULL OR @Time IS NULL OR @NumberOfPlayers IS NULL
    BEGIN
        PRINT 'One or more required parameters are NULL.';
        RETURN;
    END

    -- Check for an existing tee time
    SET @PlayerCount = (SELECT ISNULL(SUM(NumberOfPlayers), 0) FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time);

    IF @PlayerCount >= 4
    BEGIN
        PRINT 'This slot is fully booked.';
        RETURN;
    END

    -- Insert or update tee times
    IF EXISTS (SELECT 1 FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time AND MemberID = @PlayerID)
    BEGIN
        IF @PlayerCount + @NumberOfPlayers > 4
        BEGIN
            PRINT 'Cannot have more than 4 players.';
            RETURN;
        END

        UPDATE TeeTimes
        SET NumberOfPlayers += @NumberOfPlayers
        WHERE [Date] = @Date AND TeeTime = @Time;

        INSERT INTO TeeTimePlayers (TeeTimeID, BookingPlayerID)
        VALUES ((SELECT TeeTimeID FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time AND MemberID = @PlayerID), @PlayerID);
    END
    ELSE
    BEGIN
        IF @NumberOfPlayers > 4
        BEGIN
            PRINT 'Cannot have more than 4 players.';
            RETURN;
        END

        INSERT INTO TeeTimes (MemberID, [Date], TeeTime, NumberOfPlayers, ReservationStatus)
        VALUES (@PlayerID, @Date, @Time, @NumberOfPlayers, 'Reserved');

        IF @PlayerCount + @NumberOfPlayers < 4
        BEGIN
            UPDATE TeeTimes
            SET ReservationStatus = 'Open'
            WHERE [Date] = @Date AND TeeTime = @Time;
        END

        INSERT INTO TeeTimePlayers (TeeTimeID, BookingPlayerID)
        VALUES ((SELECT TeeTimeID FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time AND MemberID = @PlayerID), @PlayerID);
    END

    -- Update reservation status based on total players
    DECLARE @TotalPlayers INT;
    SELECT @TotalPlayers = SUM(NumberOfPlayers) FROM TeeTimes WHERE [Date] = '2024-01-31' AND TeeTime = '7:00';

    IF @TotalPlayers > 3
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Reserved'
        WHERE [Date] = @Date AND TeeTime = @Time;
    END
    ELSE
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Open'
        WHERE [Date] = @Date AND TeeTime = @Time;
    END
END

EXEC BookTeeTime 2, '2024-1-31', '7:00:00', 3
DELETE FROm TeeTimePlayers  
DELETE FROm TeeTimes 
Drop Procedure BookTeeTime

CREATE PROCEDURE BookTeeTime
    @PlayerID INT,
    @Date DATE,
    @Time TIME,
	@Player1ID INT,
	@Player2ID INT,
	@Player3ID INT,
	@Player4ID INT,
    @NumberOfPlayers INT
AS
BEGIN
    DECLARE @PlayerCount INT;

	SET @PlayerCount = (SELECT ISNULL(SUM(NumberOfPlayers), 0) FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time);

    IF @PlayerCount >= 4
    BEGIN
        PRINT 'This slot is fully booked.';
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time)
	BEGIN
		IF @PlayerCount + @NumberOfPlayers > 4
			BEGIN
				PRINT 'Cannot have more than 4 players. updating old';
				RETURN;
			END
		ELSE 
			BEGIN
			 IF @PlayerCount = 1
			  BEGIN
				 UPDATE TeeTimes 
				 SET 
				  NumberOfPlayers += @NumberOfPlayers,
				  Player2ID = @Player1ID,
				  Player3ID = @Player2ID,
				  Player4ID = @Player3ID
				 WHERE [DATE] = @Date AND TeeTime = @Time
		      END
			 IF @PlayerCount = 2
			  BEGIN
			   UPDATE TeeTimes 
				 SET 
				  NumberOfPlayers += @NumberOfPlayers,
				  Player3ID = @Player1ID,
				  Player4ID = @Player2ID
				 WHERE [DATE] = @Date AND TeeTime = @Time
			  END
			IF @PlayerCount = 3
			 BEGIN
			  UPDATE TeeTimes 
				 SET 
				  NumberOfPlayers += @NumberOfPlayers,
				  Player4ID = @Player1ID
				 WHERE [DATE] = @Date AND TeeTime = @Time
		     END
		END
    END
	 ELSE
		BEGIN 
			IF @NumberOfPlayers > 4
			BEGIN
				PRINT 'Cannot have more than 4 players. inserting new';
				RETURN;
			END
	    INSERT INTO TeeTimes (MemberID, [Date], TeeTime, NumberOfPlayers, Player1ID, Player2ID, Player3ID, Player4ID, ReservationStatus)
        VALUES (@PlayerID, @Date, @Time, @NumberOfPlayers, @Player1ID, @Player2ID, @Player3ID, @Player4ID, 'Reserved');

		IF @PlayerCount + @NumberOfPlayers < 4
        BEGIN
            UPDATE TeeTimes
            SET ReservationStatus = 'Open'
            WHERE [Date] = @Date AND TeeTime = @Time;
        END
		 -- Update reservation status based on total players
    DECLARE @TotalPlayers INT;
    SELECT @TotalPlayers = SUM(NumberOfPlayers) FROM TeeTimes WHERE [Date] = @Date AND TeeTime = @Time;

    IF @TotalPlayers = 4
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Reserved'
        WHERE [Date] = @Date AND TeeTime = @Time;
    END
    ELSE
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Open'
        WHERE [Date] = @Date AND TeeTime = @Time;
	END
  END
END

EXEC BookTeeTime 1, '2024-1-31', '7:00:00',1,2,0,0, 2

EXEC BookTeeTime 2, '2024-1-31', '7:00:00',1,2,0,0, 2


DELETe FROm TeeTimes


DROP Procedure UpdateTeeTime

CREATE PROCEDURE UpdateTeeTime
    @TeeTimeID INT,
    @PlayerID INT,
    @Date DATE,
    @Time TIME,
    @NewPlayer1ID INT,
    @NewPlayer2ID INT,
    @NewPlayer3ID INT,
    @NewPlayer4ID INT,
    @NumberOfPlayers INT
AS
BEGIN
    DECLARE @PlayerCount INT;

    -- Get the current number of players booked for the tee time
    SET @PlayerCount = (SELECT ISNULL(NumberOfPlayers, 0) FROM TeeTimes WHERE TeeTimeID = @TeeTimeID);

    IF @PlayerCount = 0
    BEGIN
        PRINT 'No booking found for the specified TeeTimeID.';
        RETURN;
    END

    --IF @PlayerCount + @NumberOfPlayers > 4
    --BEGIN
    --    PRINT 'Cannot have more than 4 players.';
    --    RETURN;
    --END

    -- Update the tee time booking
    UPDATE TeeTimes 
    SET 
        Player1ID = @NewPlayer1ID,
        Player2ID = @NewPlayer2ID,
        Player3ID = @NewPlayer3ID,
        Player4ID = @NewPlayer4ID,
        NumberOfPlayers = @NumberOfPlayers
    WHERE TeeTimeID = @TeeTimeID;

    -- Update reservation status based on total players
    DECLARE @TotalPlayers INT;
    SELECT @TotalPlayers = SUM(NumberOfPlayers) FROM TeeTimes WHERE TeeTimeID = @TeeTimeID;

    IF @TotalPlayers = 4
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Reserved'
        WHERE TeeTimeID = @TeeTimeID;
    END
    ELSE
    BEGIN
        UPDATE TeeTimes
        SET ReservationStatus = 'Open'
        WHERE TeeTimeID = @TeeTimeID;
    END

    PRINT 'Tee time booking updated successfully.';
END


EXEC UpdateTeeTime 24, 1018,'2024-04-02', '7:00:00', 1013, 0,0,0,1






	INSERT INTO Members (
    FirstName,
    LastName,
    Address,
    City,
    Province,
    Country,
    PostalCode,
    Phone,
    Email,
    MemberPassword,
    Salt,
    DateOfBirth,
    MembershipType,
    Sponsor1ID,
    Sponsor2ID,
    ApplicationStatus,
    DateJoined
)
VALUES (
    'Eric',
    'Ekwom',
    '123 Main St',
    'Anytown',
    'Province1',
    'Country1',
    'A1B 2C3',
    '555-1234',
    'ekwom.doe@example.com',
    'hashed_password', -- Replace with your hashed password
    'random_salt',     -- Replace with your random salt
    '1990-01-01',
    'ShareHolder',            -- Replace with the desired membership type
    123,               -- Replace with an actual Sponsor1ID
    456,               -- Replace with an actual Sponsor2ID
    'Approved',         -- Replace with the desired application status
    GETDATE()          -- Use the current date and time
);

-- Execute the stored procedure with random values
EXEC CreateApplication 
    'John',
    'Doe',
    '123 Main St',
    'Anytown',
    'Province1',
    'Country1',
    'A1B 2C3',
    '555-1234',
    'john.doe@example.com',
    'hashed_password',
    '1990-02-25',  -- Correct date format (YYYY-MM-DD)
    'Gold',
    1,  -- Replace with an actual Sponsor1ID
    2,  -- Replace with an actual Sponsor2ID
    'random_salt',
    'Pending',
    '2023-02-25';  -- C
GO
CREATE PROCEDURE GetMember(@Email NVARCHAR(100))
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
BEGIN

    IF @Email IS NULL
        RAISERROR('Email Cannot BE Null', 16, 1);
	ELSE
	SELECT * FROM Members WHERE Email = @Email
IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE
		RAISERROR ('Get User - Find error: Users table.', 16, 1)
	END
RETURN @ReturnCode
GO
CREATE PROCEDURE GetMemberByID(@MemberID INT)
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
BEGIN

    IF @MemberID IS NULL
        RAISERROR('PlayerID Cannot BE Null', 16, 1);
	ELSE
	SELECT * FROM Members WHERE MemberID = @MemberID
IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE
		RAISERROR ('Get User - Find error: Users table.', 16, 1)
	END
RETURN @ReturnCode

Exec GetMemberByID 1
GO
CREATE PROCEDURE GetAllMembers
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
BEGIN
	SELECT * FROM Members 
IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE
		RAISERROR ('Get Member - Find error: Members table.', 16, 1)
	END
RETURN @ReturnCode

Exec GetAllMembers
GO
CREATE PROCEDURE GetAllMemberApplications
AS
DECLARE @ReturnCode INT
	SET @ReturnCode = 1
BEGIN
	SELECT * FROM ClubMemberApplications 
IF @@ERROR = 0
		SET @ReturnCode = 0
	ELSE
		RAISERROR ('Get Member - Find error: Members table.', 16, 1)
	END
RETURN @ReturnCode
Delete From Members where MemberID = 1011

GO
Create Procedure UpdateMember      (@FirstName varchar(50), @LastName VARCHAR(50),
									@Address VARCHAR(255),  @City VARCHAR(255),
									@Province VARCHAR(255), @Country VARCHAR(255),
									@PostalCode VARCHAR(10),@Phone VARCHAR(20),
									@Email VARCHAR(100), @DateOfBirth DATE,   
									@MembershipType VARCHAR(20),@ApplicationStatus VARCHAR(20),
									@MemberID INT)
AS
	IF @FirstName is NULL 
	 RAISERROR ('The FirstName Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @LastName IS NULL 
	 RAISERROR ('The LastName Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Address IS NULL 
	 RAISERROR ('The Address Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Phone IS NULL 
	 RAISERROR ('The Phone Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @Email IS NULL 
	 RAISERROR ('The Email Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @DateOfBirth IS NULL 
	 RAISERROR ('The DateOfBirth Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE IF @MembershipType IS NULL 
	 RAISERROR ('The MembershipType Cannot Be Empty ~ INSERT ERROR',0,1)
	ELSE
	BEGIN
		Update Members
			SET 
				FirstName = @Firstname,
				LastName = @LastName,
				Address = @Address,
				City = @City,
				Province = @Province,
				Country = @Country,
				PostalCode = @PostalCode,
				Phone = @Phone,
				Email = @Email,
				DateOfBirth = @DateOfBirth,
				MembershipType = @MembershipType,
				ApplicationStatus = @ApplicationStatus,
				Prospective = 0

			WHERE MemberID = @MemberId

			Update ClubMemberApplications
			SET 
			ApplicationStatus = @ApplicationStatus
			WHERE ApplicantID = @MemberID
		
	END
	Drop Procedure UpdateMember
GO
Create Procedure GetTeeTime(@Date DATE, @Time TIME)
AS
 BEGIN
  SELECT * FROM TeeTimes
  WHERE Teetimes.Date =  @Date AND Teetimes.TeeTime = @Time
 END

EXEC GetTeeTime  '2024-1-31', '7:00:00'
GO
Create Procedure GetMemberTeeTime(@MemberId INT)
AS
 BEGIN
  SELECT * FROM TeeTimes
  WHERE MemberID =  @MemberId
END

GO
Create Procedure CancelTeeTimeReservaion(@TeeTimeID INT)
AS
BEGIN 
 DELETE FROM TeeTimePlayers WHERE TeeTimeID = @TeeTimeID
 DELETE FROM TeeTimes WHERE TeeTimeID = @TeeTimeID
 END

DROP PROCEDURE CancelTeeTimeReservaion

EXEC CancelTeeTimeReservaion 38

GO
Create Procedure GetTeeTimeByID(@TeeTimeID INT)
AS
 BEGIN
  SELECT * FROM TeeTimes
  WHERE TeeTimeID =  @TeeTimeID 
 END

 Exec GetTeeTimeByID 40

GO
Create Procedure DeleteMemberAccount (@MemberID INT)
AS
	BEGIN
		DELETE From ClubMemberApplications WHERE ApplicantID = @MemberID
		DELETE FROM Members WHERE MemberID = @MemberID 
	END

Go
CREATE PROCEDURE InsertGolfScores
    @PlayerName VARCHAR(50),
	@MemberID INT,
    @PlayerNumber INT,
    @Player1Name VARCHAR(50),
    @Player2Name VARCHAR(50),
    @Player3Name VARCHAR(50),
    @Player4Name VARCHAR(50),
    @Date DATE,
    @Hole1Score INT,
    @Hole2Score INT,
    @Hole3Score INT,
    @Hole4Score INT,
    @Hole5Score INT,
    @Hole6Score INT,
    @Hole7Score INT,
    @Hole8Score INT,
    @Hole9Score INT,
    @Hole10Score INT,
    @Hole11Score INT,
    @Hole12Score INT,
    @Hole13Score INT,
    @Hole14Score INT,
    @Hole15Score INT,
    @Hole16Score INT,
    @Hole17Score INT,
    @Hole18Score INT,
	@TotalScore INT
AS
BEGIN
    INSERT INTO Scores (
        PlayerName,
		MemberID,
        PlayerNumber,
        Player1Name,
        Player2Name,
        Player3Name,
        Player4Name,
        Date,
        Hole1Score,
        Hole2Score,
        Hole3Score,
        Hole4Score,
        Hole5Score,
        Hole6Score,
        Hole7Score,
        Hole8Score,
        Hole9Score,
        Hole10Score,
        Hole11Score,
        Hole12Score,
        Hole13Score,
        Hole14Score,
        Hole15Score,
        Hole16Score,
        Hole17Score,
        Hole18Score,
        TotalScore
    )
    VALUES (
        @PlayerName,
		@MemberID,
        @PlayerNumber,
        @Player1Name,
        @Player2Name,
        @Player3Name,
        @Player4Name,
        @Date,
        @Hole1Score,
        @Hole2Score,
        @Hole3Score,
        @Hole4Score,
        @Hole5Score,
        @Hole6Score,
        @Hole7Score,
        @Hole8Score,
        @Hole9Score,
        @Hole10Score,
        @Hole11Score,
        @Hole12Score,
        @Hole13Score,
        @Hole14Score,
        @Hole15Score,
        @Hole16Score,
        @Hole17Score,
        @Hole18Score,
        @TotalScore
    );
END;
DROP PROCEDURE InsertGolfScores
Go

CREATE PROCEDURE GetMemberScoresByDate
    @MemberID INT,
    @Date DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Scores
    WHERE Scores.MemberID = @MemberID
      AND Scores.Date = @Date;
END;

CREATE PROCEDURE UpdateClubMemberApplication
    @ApplicationID INT,
    @Shareholder1Status NVARCHAR(50),
    @Shareholder2Status NVARCHAR(50)
AS
BEGIN
    UPDATE ClubMemberApplications
    SET 
        Shareholder1Status = @Shareholder1Status,
        Shareholder2Status = @Shareholder2Status
    WHERE ApplicationID = @ApplicationID;
END;