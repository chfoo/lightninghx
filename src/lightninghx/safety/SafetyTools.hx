package lightninghx.safety;


class SafetyTools {
    public static function requireState(current:EnumValue, expected:EnumValue) {
        if (current != expected) {
            throw new Exception.InvalidStateException('Current $current, expected $expected');
        }
    }

    public static function disallowState(current:EnumValue, unexpected:EnumValue) {
        if (current == unexpected) {
            throw new Exception.InvalidStateException('Unexpected $current');
        }
    }
}
