package com.wyn.crm.mapper;

import com.wyn.crm.entity.TranHistory;
import com.wyn.crm.entity.TranHistoryExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface TranHistoryMapper {
    int countByExample(TranHistoryExample example);

    int deleteByExample(TranHistoryExample example);

    int deleteByPrimaryKey(String id);

    int insert(TranHistory record);

    int insertSelective(TranHistory record);

    List<TranHistory> selectByExample(TranHistoryExample example);

    TranHistory selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") TranHistory record, @Param("example") TranHistoryExample example);

    int updateByExample(@Param("record") TranHistory record, @Param("example") TranHistoryExample example);

    int updateByPrimaryKeySelective(TranHistory record);

    int updateByPrimaryKey(TranHistory record);

    List<TranHistory> getAll();
}