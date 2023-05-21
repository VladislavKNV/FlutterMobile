using ILike.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ILike.Repository
{
	public class RepositoryDB
	{
		//string connectionString = "Data Source=(local);Initial Catalog=ForFlutter;Integrated Security=true";
		string connectionString = "Server=93.125.10.36;Database=ForFlutter;Integrated Security=false;User Id=Vlad;Password=50511007;";

		public List<Article> GetArticle()
		{
			var articlesList = new List<Article>();
			var queryString = "select id,title,imageUrl,content from Articles";

			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				connection.Open();

				using (var reader = command.ExecuteReader())
				{
					while (reader.Read())
					{
						object dbVal = null;

						var article = new Article();
						article.id = (int)reader.GetValue(0);

						dbVal = reader.GetValue(1);
						if (!(dbVal is DBNull))
						{
							article.title = (dbVal as string).Trim();
						}

						dbVal = (string)reader.GetValue(2);
						if (!(dbVal is DBNull))
						{
							article.imageUrl = (dbVal as string).Trim();
						}

						dbVal = (string)reader.GetValue(3);
						if (!(dbVal is DBNull))
						{
							article.content = (dbVal as string).Trim();
						}


						articlesList.Add(article);
					}
				}
			}
			return articlesList;
		}

	}
}