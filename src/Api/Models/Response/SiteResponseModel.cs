﻿using System;
using Bit.Core.Domains;

namespace Bit.Api.Models
{
    public class SiteResponseModel : ResponseModel
    {
        public SiteResponseModel(Cipher cipher)
            : base("site")
        {
            if(cipher == null)
            {
                throw new ArgumentNullException(nameof(cipher));
            }

            if(cipher.Type != Core.Enums.CipherType.Site)
            {
                throw new ArgumentException(nameof(cipher.Type));
            }

            var data = new SiteDataModel(cipher);

            Id = cipher.Id.ToString();
            FolderId = cipher.FolderId?.ToString();
            Favorite = cipher.Favorite;
            Name = data.Name;
            Uri = data.Uri;
            Username = data.Username;
            Password = data.Password;
            Notes = data.Notes;
            RevisionDate = cipher.RevisionDate;
        }

        public string Id { get; set; }
        public string FolderId { get; set; }
        public bool Favorite { get; set; }
        public string Name { get; set; }
        public string Uri { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Notes { get; set; }
        public DateTime RevisionDate { get; set; }

        // Expandables
        public FolderResponseModel Folder { get; set; }
    }
}
