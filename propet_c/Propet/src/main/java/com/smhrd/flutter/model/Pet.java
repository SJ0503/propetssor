package com.smhrd.flutter.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity(name="pet")
@Getter
@Setter
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "p_idx")
    private long pidx;

    @Column(name ="p_name", length = 50)
    private String pname;

    @Column(name ="p_kind", length = 50)
    private String pkind;

    @Column(name ="p_age")
    private Long page;

    @Column(name = "p_kg", precision = 4, scale = 2)
    private BigDecimal pKg;

    @Column(name ="p_gender", length = 50)
    private String pgender;

    @Column(name ="p_surgery", length = 50)
    private String psurgery;

    @Column(name ="p_disease", length = 50)
    private String pdisease;

    @Column(name ="p_diseaseinf", length = 50)
    private String pdiseaseinf;

    @Column(name ="u_idx")
    private long uidx;
    
    @Column(name = "p_image")
    private String pimage;
}
