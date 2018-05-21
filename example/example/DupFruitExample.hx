package example;

import haxe.io.Bytes;
import lightninghx.CursorOperation;
import lightninghx.DatabaseFlags;
import lightninghx.EnvironmentFlags;
import lightninghx.Exception;
import lightninghx.Lightning;


class DupFruitExample {
    public static function main() {
        var environment = Lightning.environment();
        environment.setMapSize(2147483647);
        environment.open("example_dup_fruit_db/");

        var transaction = environment.beginTransaction();
        var database = transaction.openDatabase(DatabaseFlags.DupSort);

        database.put(Bytes.ofString("apple"), Bytes.ofString("red"));
        database.put(Bytes.ofString("apple"), Bytes.ofString("green"));
        database.put(Bytes.ofString("apple"), Bytes.ofString("yellow"));
        database.put(Bytes.ofString("banana"), Bytes.ofString("yellow"));

        transaction.commit();

        transaction = environment.beginTransaction(EnvironmentFlags.ReadOnly);
        database = database.reuse(transaction);

        var appleColors = [];
        var cursor = database.openCursor();

        var pair = cursor.get(CursorOperation.SetKey, Bytes.ofString("apple"));
        appleColors.push(pair.data.toString());

        while (true) {
            try {
                pair = cursor.get(CursorOperation.NextDup);
            } catch (exception:NotFoundException) {
                break;
            }

            appleColors.push(pair.data.toString());
        }

        transaction.abort();

        trace('The colors of an apple are ${appleColors.join(", ")}.');

        environment.close();
    }
}
