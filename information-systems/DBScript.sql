CREATE TABLE [dbo].[Uporabnik] (
    [username] VARCHAR (20) NOT NULL,
    [ime]      VARCHAR (20) NOT NULL,
    [priimek]  VARCHAR (20) NOT NULL,
    [geslo]    VARCHAR (50) NOT NULL,
    [isadmin]  BIT          NULL,
    PRIMARY KEY CLUSTERED ([username] ASC)
);

CREATE TABLE [dbo].[Pogovor] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [username]     VARCHAR (20)  NOT NULL,
    [besedilo]     VARCHAR (100) NOT NULL,
    [poslano_time] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([username]) REFERENCES [dbo].[Uporabnik] ([username])
);

