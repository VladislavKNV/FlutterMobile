using ILike.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Helpers;

namespace ILike.Repository
{
	public class RepositoryDB
	{
		//string connectionString = "Data Source=(local);Initial Catalog=ForFlutter;Integrated Security=true";
		string connectionString = "Server=93.125.10.36;Database=ForFlutter;Integrated Security=false;User Id=Vlad;Password=50511007;";

		public List<ArticleModel> GetArticle()
		{
			var articlesList = new List<ArticleModel>();
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

						var article = new ArticleModel();
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

		public UserModel GetUserByLogin(string Login)
		{
			UserModel user = null;
			var queryString = "select top 1 Login,Email,Password from Users where Login=@Login";//sql запрос

			// Создание и открытие соединения в блоке using.
			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@Login", Login);
				// Создание объеков команд и параметров.
				connection.Open();

				using (var reader = command.ExecuteReader())
				{
					if (reader.Read())
					{
						user = new UserModel();
						user.Login = (string)reader.GetValue(0);
						user.Email = (string)reader.GetValue(1);
						user.Password = (string)reader.GetValue(2);
					}
				}
				return user;
			}

		}

		public List<CommentModel> GetComment(int IdArticle)
		{
			var commentsList = new List<CommentModel>();
			var queryString = "select id,idArticle,LoginUser,Comment from Comments where idArticle=@idArticle";

			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@idArticle", IdArticle);
				connection.Open();

				using (var reader = command.ExecuteReader())
				{
					while (reader.Read())
					{
						object dbVal = null;

						var commentModel = new CommentModel();
						commentModel.id = (int)reader.GetValue(0);
						commentModel.idArticle = (int)reader.GetValue(1);

						dbVal = reader.GetValue(2);
						if (!(dbVal is DBNull))
						{
							commentModel.LoginUser = (dbVal as string).Trim();
						}

						dbVal = (string)reader.GetValue(3);
						if (!(dbVal is DBNull))
						{
							commentModel.Comment = (dbVal as string).Trim();
						}

						commentsList.Add(commentModel);
					}
				}
			}
			return commentsList;
		}

		public bool AddArticle(string NewTitle, string NewUrlImage, string NewContent)
		{
			var queryString = "INSERT INTO Articles (title, imageUrl, content) VALUES (@title, @imageUrl, @content)";

			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@title", NewTitle);
				command.Parameters.AddWithValue("@imageUrl", NewUrlImage);
				command.Parameters.AddWithValue("@content", NewContent);

				connection.Open();

				command.ExecuteNonQuery();
			}
			return true;
		}

		public bool AddUser(UserModel user)
		{
			var queryString = "INSERT INTO Users (Login, Email, Password) VALUES (@login, @email, @password)";

			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@login", user.Login);
				command.Parameters.AddWithValue("@email", user.Email);
				command.Parameters.AddWithValue("@password", user.Password);

				connection.Open();

				command.ExecuteNonQuery();
			}
			return true;
		}

		public bool AddComment(CommentModel commentModel)
		{
			var queryString = "INSERT INTO Comments (idArticle, LoginUser, Comment) VALUES (@idArticle, @LoginUser, @Comment)";

			using (var connection = new SqlConnection(connectionString))
			{
				var command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@idArticle", commentModel.idArticle);
				command.Parameters.AddWithValue("@LoginUser", commentModel.LoginUser);
				command.Parameters.AddWithValue("@Comment", commentModel.Comment);

				connection.Open();

				command.ExecuteNonQuery();
			}
			return true;
		}

	}
}