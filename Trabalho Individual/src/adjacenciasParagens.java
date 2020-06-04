import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;

public class adjacenciasParagens {
    private int paragem1;
    private int paragem2;
    private int carreira;

    public adjacenciasParagens(int paragem1, int paragem2, int carreira) {
        this.paragem1 = paragem1;
        this.paragem2 = paragem2;
        this.carreira = carreira;
    }

    public int getParagem1() {
        return paragem1;
    }

    public int getParagem2() {
        return paragem2;
    }

    public int getCarreira() {
        return carreira;
    }

    @Override
    public String toString() {
        return "adjacenciasParagens(" + paragem1 + "," + paragem2 + "," + carreira + ").";
    }
}
