package com.itCat.crmEX.commons.utils;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Random;

/**
 * 创建验证码图片
 */
public class CreateValidateCode {

    /**
     * 图像
     */
    private BufferedImage image;

    /**
     * 验证码
     */
    private String code;

    private char[] pro = "qwertyuiopasdfghjklzxcvbnmQAZWSXEDCVFRTGBNHYUJMKIOLP1234567890".toCharArray();

    /**
     * 存放验证码的键
     */
    public static final String CHECK_CODE_SERVER = "CHECK_CODE_SERVER";

    public CreateValidateCode(){
        init();
    }

    public static CreateValidateCode Instance(){
        return new CreateValidateCode();
    }

    /**
     * 获得验证码图片
     * @return
     */
    public BufferedImage getImage(){
        return this.image;
    }

    /**
     * 获得图片的验证码
     * @return
     */
    public String getCode(){
        return this.code.toLowerCase();
    }

    /**
     * 初始化图像
     */
    private void init(){
        //在内存中创建一个图像
        int width = 60, height = 30;
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        //获得画布
        Graphics g = image.getGraphics();
        //生成随机类
        Random random = new Random();
        //设置背景色
        g.setColor(getRandColor(200, 250));
        g.fillRect(0, 0, width, height);
        //设定字体
        g.setFont(new Font("Times New Roman", Font.PLAIN, 16));
        //随机产生干扰线
        g.setColor(getRandColor(160, 200));
        for (int i = 0; i < 101; i++) {
            int x = random.nextInt(width);
            int y = random.nextInt(height);
            int fx = random.nextInt(12);
            int fy = random.nextInt(12);
            g.drawLine(x, y, x + fx, y + fy);
        }
        //取得随机产生的验证码
        String code = "";
        for (int i = 0; i < 4; i++) {
            int index = random.nextInt(pro.length);
            String rand = String.valueOf(pro[index]);
            code += rand;
            //将验证码显示在图像中
            g.setColor(new Color(20 + random.nextInt(110), 20 + random.nextInt(110), 20 + random.nextInt(110)));
            g.drawString(rand, 13 * i + 6, 21);
        }
        this.code = code;
        //图像生效
        g.dispose();
        //赋值图像
        this.image = image;
    }

    /**
     * 给定范围获得随机颜色
     * @param fc
     * @param bc
     * @return
     */
    private Color getRandColor(int fc, int bc){
        Random random = new Random();
        if (fc > 255){
            fc = 255;
        }
        if (bc > 255){
            bc = 255;
        }
        int r = fc + random.nextInt(bc - fc);
        int g = fc + random.nextInt(bc - fc);
        int b = fc + random.nextInt(bc - fc);
        return new Color(r, g, b);
    }

}
