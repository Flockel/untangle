import java.util.Locale;

static class Texts {
  public static String getText(Locale locale, String text) {
    if (locale == null) locale = Locale.getDefault();
    String language = locale.getLanguage();
    if ("de".equals(language)) {
      switch (text) {
        case "restart": return "Neustart/Nächste Runde";
        case "finished": return "Fertig!";
      }
    } else {
      switch (text) {
        case "restart": return "Restart/Next round";
        case "finished": return "Finished!";
      }
    }
    return "unexpected text: " + text;
  }
}