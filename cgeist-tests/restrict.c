void subview_hoist_static(float * restrict slice0, float * restrict slice1) {
    slice0[0] = 0.0f;

    for (int i = 0; i < 512; i++) {
        float inv = slice0[0];
        float x   = slice0[i];
        float y   = x + inv;
        slice1[i] = y;
    }
}
