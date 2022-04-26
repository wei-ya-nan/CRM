package com.wyn.crm.mapper;

import com.wyn.crm.entity.DicValue;
import com.wyn.crm.entity.DicValueExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface DicValueMapper {
    int countByExample(DicValueExample example);

    int deleteByExample(DicValueExample example);

    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    List<DicValue> selectByExample(DicValueExample example);

    DicValue selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") DicValue record, @Param("example") DicValueExample example);

    int updateByExample(@Param("record") DicValue record, @Param("example") DicValueExample example);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);

    List<DicValue> queryDicValueByTypeCode(@Param("stage") String stage);

}