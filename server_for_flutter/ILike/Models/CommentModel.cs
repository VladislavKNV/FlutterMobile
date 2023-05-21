using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ILike.Models
{
	public class CommentModel
	{
		public int id { get; set; }
		public int idArticle { get; set; }
		public string LoginUser { get; set; }
		public string Comment { get; set; }
	}
}