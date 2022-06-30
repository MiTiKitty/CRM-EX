package com.itCat.crmEX.settings.domain;

public class DictionaryType {
    private String code;

    private String name;

    private String description;

    public DictionaryType(String code, String name, String description) {
        this.code = code;
        this.name = name;
        this.description = description;
    }

    public DictionaryType() {
        super();
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code == null ? null : code.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }
}