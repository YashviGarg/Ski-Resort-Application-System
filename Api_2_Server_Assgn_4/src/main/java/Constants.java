public class Constants {

  // URL Error Messages
  public static final String MSG_METHOD_NOT_ALLOWED = "POST Method not allowed. Use GET method instead.";
  public static final String MSG_DATA_NOT_FOUND = "Data not found";
  public static final String MSG_INVALID_INPUTS = "Invalid Inputs Provided";

  // Servlet Messages
  public static final String SERVLET_EST = "Servlet initialized.";
  public static final String SERVLET_EST_ERROR = "Could Not Initialize Servlet.";

  // Cache Messages
  public static final String CACHE_EST = "Cache Connection established.";
  public static final String CACHE_CONNECTION_ERROR_MESSAGE = "Error connecting to Cache.";
  public static final String CACHE_INSERT_ERROR_MESSAGE = "Could not insert data into Cache.";
  public static final String CACHE_FETCH_ERROR_MESSAGE = "Could not extract data from Cache.";

  //DB Messages
  public static final String DATABASE_CON_EST = "Database Connection established.";
  public static final String DB_CONNECTION_ERROR_MESSAGE = "Error connecting to Database";
  public static final String DB_FETCH_ERROR_MESSAGE = "Could not extract data from DynamoDB";

  //
  public static final String SKIERS_DAY_VERTICAL_URL_PATTERN = "/\\d+/seasons/\\d+/days/\\d+/skiers/\\d+";
  public static final String URL_DELIMITER = "/";

  // Cache Redis Credentials
  public static final String REDIS_HOST = "54.185.57.67";
  public static final Integer REDIS_PORT = 6379;

  // AWS DynamoDB Credentials
  public static final String TABLE_NAME = "SkierLiftRidesData_Final";
  public static final String INDEX_NAME = "resortID-dayID-index";
  public static final String AWS_ACCESS_KEY = System.getenv("AWS_ACCESS_KEY");
  public static final String AWS_SECRET_KEY = System.getenv("AWS_SECRET_KEY");
  public static final String AWS_SESSION_TOKEN = System.getenv("AWS_SESSION_TOKEN");
  public static final String AWS_REGION = "us-west-2";
}
