public class Constants {
  public static final String MSG_METHOD_NOT_ALLOWED = "POST Method not allowed. Use GET method instead.";
  public static final String MSG_INVALID_INPUTS = "Invalid Inputs Provided";
  public static final String MSG_DATA_NOT_FOUND = "Data not found";


  // Cache Messages
  public static final String CACHE_EST = "CACHE Connection established.";
  public static final String CACHE_CONNECTION_ERROR_MESSAGE = "Error connecting to Redis Cache";
  public static final String ERROR_INSERT_CACHE = "Could not insert data into Cache.";
  public static final String CACHE_FETCH_ERROR_MESSAGE = "Could not extract data from Redis";


  // Servlet Messages
  public static final String SERVLET_EST = "Servlet initialized.";
  public static final String SERVLET_EST_ERROR = "Could Not Initialize Servlet.";

  //DB Messages
  public static final String DATABASE_CON_EST = "Database Connection established.";
  public static final String DB_CONNECTION_ERROR_MESSAGE = "Error connecting to Database";
  public static final String DB_FETCH_ERROR_MESSAGE = "Could not extract data from Database";

  //
  public static final String SKIERS_TOTAL_VERTICAL_URL_PATTERN = "/\\d+/vertical";
  public static final String URL_DELIMITER = "/";
  public static final String PARAM_1= "resort";
  public static final String PARAM_2= "season";


  // Cache Redis Credentials
  public static final String REDIS_HOST = "34.222.26.62";
  public static final Integer REDIS_PORT = 6379;


  // AWS DynamoDB Credentials
  public static final String TABLE_NAME = "SkierLiftRidesData_Final";
  public static final String INDEX_NAME = "skierID-resortID-index";
  public static final String AWS_ACCESS_KEY = System.getenv("AWS_ACCESS_KEY");
  public static final String AWS_SECRET_KEY = System.getenv("AWS_SECRET_KEY");
  public static final String AWS_SESSION_TOKEN = System.getenv("AWS_SESSION_TOKEN");
  public static final String AWS_REGION = "us-west-2";

}
