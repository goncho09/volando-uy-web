package uy.volando.soap;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class VolandoConfig {

    private static final Properties props = new Properties();
    private static boolean initialized = false;

    public static void init() {
        if (initialized) return; // evita inicialización doble
        String homeDir = System.getProperty("user.home");
        String configPath = homeDir + "/volandouyFiles/app.properties"; // archivo externo
        try (FileInputStream fis = new FileInputStream(configPath)) {
            props.load(fis);
            initialized = true;
        } catch (IOException e) {
            throw new RuntimeException("No se pudo leer app.config", e);
        }
    }

    public static String get(String key) {
        if (!initialized) init();
        return props.getProperty(key);
    }
}
