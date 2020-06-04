import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class baseConhecimento {

    public static int adicionaBaseParagens(String filename) throws IOException {
        File in = new File(filename);
        FileInputStream fis = new FileInputStream(in);
        BufferedReader br = new BufferedReader(new InputStreamReader(fis));

        FileWriter fos = new FileWriter("baseConhecimento.prolog.BB.pl", true);
        BufferedWriter out = new BufferedWriter(fos);

        String line = br.readLine();
        line = br.readLine(); //Começar a ler da segunda linha

        while(line != null){
            paragensOeiras paragem = paragensOeiras.lerLinhaToParagem(line); //lê a linha da paragem e valida
            if (paragem != null){
                out.write(paragem.toString());
                out.newLine();
                out.flush();
            }
            line = br.readLine();
        }
        out.close();
        return 0;
    }

    public static int adicionaBaseAdjacentes() throws IOException{
        File folder = new File("/Users/carolina/Desktop/parser/carreiras");
        File[] listOfFiles = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".csv"));

        FileWriter fos = new FileWriter("/Users/carolina/Desktop/parser/baseConhecimento.prolog.BB.pl", true);
        BufferedWriter out = new BufferedWriter(fos);

        for (File file : listOfFiles) {
            if (file.isFile()) {
                FileInputStream fis = new FileInputStream(file);
                BufferedReader br = new BufferedReader(new InputStreamReader(fis));

                adjacenciasParagens a;
                int p1 = 0;
                int p2 = 0;
                int carreira = 0;

                String line = br.readLine();
                line = br.readLine(); //Começar a ler da segunda linha

                while(line != null) {
                    String[] campos = line.split(",");

                    if (campos != null) {
                        p1 = Integer.parseInt(campos[0]);
                        carreira = Integer.parseInt(campos[7]);
                    }

                    line = br.readLine();
                    if(line == null) break;
                    campos = line.split(",");

                    if (campos != null) {
                        p2 = Integer.parseInt(campos[0]);
                    }

                    a = new adjacenciasParagens(p1,p2,carreira);
                    if (p1 == p2) a = null;
                    if (a != null) {
                        out.write(a.toString());
                        out.newLine();
                        out.flush();
                    }
                    //line = br.readLine();
                }

            }

        }
        out.close();
        return 0;
    }


    public static void main(String[] args) throws IOException {
        adicionaBaseParagens("/Users/carolina/Desktop/parser/src/paragem_autocarros_oeiras_processado_4.csv");
        adicionaBaseAdjacentes();
    }

}