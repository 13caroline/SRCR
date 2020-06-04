import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;

public class paragensOeiras {
    private int gid;
    private double latitude;
    private double longitude;
    private String estado;
    private String tipo;
    private String publicidade;
    private String operadora;
    private List<Integer> carreira;
    private int codigo;
    private String rua;
    private String freguesia;


    public paragensOeiras(int gid, double latitude, double longitude, String estado, String tipo, String publicidade, String operadora, List<Integer> carreira, int codigo, String rua, String freguesia) {
        this.gid = gid;
        this.latitude = latitude;
        this.longitude = longitude;
        this.estado = estado;
        this.tipo = tipo;
        this.publicidade = publicidade;
        this.operadora = operadora;
        this.carreira = carreira;
        this.codigo = codigo;
        this.rua = rua;
        this.freguesia = freguesia;
    }

    public int getGid() {
        return gid;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getEstado() {
        return estado;
    }

    public String getTipo() {
        return tipo;
    }

    public String getPublicidade() {
        return publicidade;
    }

    public String getOperadora() {
        return operadora;
    }

    public List<Integer> getCarreira() {
        return carreira;
    }

    public int getCodigo() {
        return codigo;
    }

    public String getRua() {
        return rua;
    }

    public String getFreguesia() {
        return freguesia;
    }

    public static paragensOeiras lerLinhaToParagem(String linha){
        int gid = 0;
        double latitude = 0.0;
        double longitude = 0.0;
        String estado, tipo, publicidade, operadora, rua, freguesia;
        List<Integer> carreira = new ArrayList<>();
        int codigo = 0;

        String[] campos = linha.split(";");
        if (campos.length != 11) return null;

        estado = campos[3];
        tipo = campos[4];
        publicidade = campos[5];
        operadora = campos[6];
        String[] carreiras = campos[7].split(",");
        for (String c : carreiras) {
            carreira.add(Integer.parseInt(c));
        }
        rua = campos[9];
        freguesia = campos[10];

        if (estado == null || tipo == null || publicidade == null || operadora == null || rua == null || freguesia == null ) return null;
        if (carreiras.length == 0) return null;

        try{
            gid = Integer.parseInt(campos[0]);
        }
        catch (NumberFormatException | InputMismatchException exc) {
            return null;
        }

        try{
            latitude = Double.parseDouble(campos[1]);
        }
        catch (NumberFormatException | InputMismatchException exc){
            return null;
        }

        try{
            longitude = Double.parseDouble(campos[2]);
        }
        catch (NumberFormatException | InputMismatchException exc){
            return null;
        }

        try{
            codigo = Integer.parseInt(campos[8]);
        }
        catch (NumberFormatException | InputMismatchException exc){
            return null;
        }

       return new paragensOeiras(gid, latitude, longitude, estado, tipo, publicidade, operadora, carreira, codigo, rua, freguesia);
    }

    @Override
    public String toString() {
        return "paragem(" + gid + "," + latitude + "," + longitude + "," + estado.toLowerCase() + "," + '"' + tipo.toLowerCase() + '"' + "," + publicidade.toLowerCase() + "," + operadora.toLowerCase() + "," + carreira + "," + codigo + "," + '"' + rua.toLowerCase() + '"' + "," + '"' + freguesia.toLowerCase() + '"' + ").";
    }
}
