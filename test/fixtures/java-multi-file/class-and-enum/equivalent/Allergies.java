class PLACEHOLDER_02 {
    private int PLACEHOLDER_15;

    PLACEHOLDER_02(int PLACEHOLDER_17) {
        this.PLACEHOLDER_15 = PLACEHOLDER_17;
    }

    List<PLACEHOLDER_01> PLACEHOLDER_04() {
        return EnumSet.allOf(PLACEHOLDER_01.class).stream()
                .filter(this::PLACEHOLDER_05)
                .collect(Collectors.toList());
    }

    boolean PLACEHOLDER_05(PLACEHOLDER_01 PLACEHOLDER_18) {
        return (PLACEHOLDER_15 & PLACEHOLDER_18.PLACEHOLDER_03()) != 0;
    }
}
