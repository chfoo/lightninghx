package lightninghx;

import utest.Runner;
import utest.ui.Report;

class TestAll {
    public static function main() {
        var runner = new Runner();
        runner.addCases(lightninghx.tests);
        Report.create(runner);
        runner.run();
    }
}
